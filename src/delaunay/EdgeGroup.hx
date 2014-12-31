package delaunay;

/**
 * Lumps together a bunch of edges that need to be merged with other groups
 */
class EdgeGroup<T: DhxPoint> {

    /** The list of edges */
    public var edges(default, null): Array<Edge<T>>;

    /** Creates a new edge group from a list of edges */
    public function new ( edges: Array<Edge<T>> ) {
        this.edges = edges;
    }
}

