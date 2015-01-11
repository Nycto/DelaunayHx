package delaunay;

/**
 * Performs a Delaunay Triangulation on a set of points
 */
class Triangulate<T: DhxPoint> {

    /** The list of points on which to operate */
    private var points: Array<T>;

    /** Constructor */
    public function new ( points: Array<T> ) {
        this.points = points;
    }

    /** Add a point */
    public inline function add ( point: T ) {
        this.points.push(point);
    }

    /** Returns a list of edges when there are only three points. */
    private static function getTrinary<T: DhxPoint>(
        points: Slice<T>
    ): EdgeGroup<T> {
        var a = points[0];
        var b = points[1];
        var c = points[2];

        if ( Triangle.isTriangle(a, b, c) ) {
            return new EdgeGroup().add(a, b).add(b, c).add(a, c);
        }
        else {
            return new EdgeGroup().add(a, b).add(b, c);
        }
    }

    /** Triangulates the edges for a list of points */
    private static function calculate<T: DhxPoint>(
        points: Slice<T>
    ): EdgeGroup<T> {
        return switch ( points.length() ) {
            case 0: throw "Can not triangulate without any points";
            case 1: throw "Can not triangulate with only one point";
            case 2: new EdgeGroup().add( points[0], points[1] );
            case 3: getTrinary(points);
            case _: DivideAndConquer.merge(
                calculate(points.splitLeft()),
                calculate(points.splitRight())
            );
        }
    }

    /** Executes a callback for each determined edge */
    public function eachEdge( callback: T -> T -> Void ): Void {
        if ( points.length > 1 ) {
            calculate(points).eachEdge(callback);
        }
    }

    /** Executes a callback for each determined edge */
    public function getEdges(): Array<Edge<T>> {
        return points.length <= 1 ? [] : calculate(points).toArray();
    }
}

