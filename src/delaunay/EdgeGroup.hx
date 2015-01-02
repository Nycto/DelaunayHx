package delaunay;

/**
 * Lumps together a bunch of edges that need to be merged with other groups
 */
class EdgeGroup<T: DhxPoint> {

    /** The list of edges */
    public var edges(default, null) = new Set<Edge<T>>(
        function ( edge ) { return edge.hashCode(); },
        function ( a, b ) { return a.equals(b); }
    );

    /** Creates a new edge group from a list of edges */
    public function new ( edges: Array<Edge<T>> ) {
        for ( edge in edges ) {
            add(edge);
        }
    }

    /** Adds an edge */
    public inline function add ( edge: Edge<T> ) {
        if ( !edges.contains(edge) ) {
            edges.add( edge );
        }
    }
}

