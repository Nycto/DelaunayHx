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

    /** Merges together sets of edges */
    private static function merge<T: DhxPoint>(
        left: EdgeGroup<T>, right: EdgeGroup<T>
    ): EdgeGroup<T> {
        return new EdgeGroup();
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
            case _: merge(
                calculate(points.splitLeft()),
                calculate(points.splitRight())
            );
        }
    }

    /** Executes a callback for each determined edge */
    public function eachEdge( callback: T -> T -> Void ): Void {
        var slice: Slice<T> = points;
        if ( slice.length() > 1 ) {
            calculate(slice).eachEdge(callback);
        }
    }

    /** Executes a callback for each determined edge */
    public function getEdges(): Array<Edge<T>> {
        var result = [];
        eachEdge(function (one, two) {
            result.push( new Edge(one, two) );
        });
        return result;
    }
}

