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
        points: Points<T>
    ): Array<Edge<T>> {
        var a = points[0];
        var b = points[1];
        var c = points[2];

        if ( Triangle.isTriangle(a, b, c) ) {
            return [ new Edge<T>(a, b), new Edge<T>(b, c), new Edge<T>(a, c) ];
        }
        else {
            return [ new Edge<T>(a, b), new Edge<T>(b, c) ];
        }
    }

    /** Executes a callback for each determined edge */
    public function getEdges(): Array<Edge<T>> {
        var nodes = new Points(points);

        return switch ( nodes.length() ) {
            case 0: [];
            case 1: [];
            case 2: [ new Edge<T>(nodes[0], nodes[1]) ];
            case 3: getTrinary(nodes);
            case _: [];
        }
    }

    /** Executes a callback for each determined edge */
    public function eachEdge( callback: T -> T -> Void ): Void {
        for ( edge in getEdges() ) {
            callback( edge.one, edge.two );
        }
    }

}

