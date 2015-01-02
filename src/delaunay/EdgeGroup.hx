package delaunay;

/**
 * Lumps together a bunch of edges that need to be merged with other groups
 */
class EdgeGroup<T: DhxPoint> {

    /** The list of edges */
    public var edges(default, never) = new Set<Edge<T>>(Edge.hash, Edge.equal);

    /** Tracks the bottom-right point in this group of edges */
    public var bottom(default, null): Null<T> = null;

    /** Creates a new edge group from a list of edges */
    public function new ( edges: Array<Edge<T>> ) {
        for ( edge in edges ) {
            add(edge);
        }
    }

    /**
     * Compares a point to the bottom-right most point already tracked. Replaces
     * that point with this one if this is further down right.
     */
    private function potentialBottomRight( point: T ) {
        if (
            bottom == null ||
            point.getY() < bottom.getY() ||
            ( point.getY() == bottom.getY() && point.getX() > bottom.getX() )
        ) {
            bottom = point;
        }
    }

    /** Adds an edge */
    public inline function add ( edge: Edge<T> ) {
        if ( !edges.contains(edge) ) {
            edges.add( edge );
            potentialBottomRight( edge.one );
            potentialBottomRight( edge.two );
        }
    }

    /** Picks the bottom right-most node in this group */
    public inline function bottomRight (): T {
        if ( bottom == null ) {
            throw "EdgeGroup does not have any points in it";
        }
        return bottom;
    }
}

