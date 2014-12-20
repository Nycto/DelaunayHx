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

    /** Executes a callback for each determined edge */
    public function eachEdge( callback: T -> T -> Void ): Void {
    }

}

