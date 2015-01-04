package delaunay;

/**
 * Lumps together a bunch of edges that need to be merged with other groups
 */
class EdgeGroup<T: DhxPoint> {

    /** The list of edges */
    private var edges(default, never) = new Set<Edge<T>>(Edge.hash, Edge.equal);

    /** A map of points to the points they are connected to */
    private var connections(default, never)
        = new BuildingHashMap<T, Set<T>>(
            RealPoint.hash, RealPoint.equal,
            function () { return new Set<T>(RealPoint.hash, RealPoint.equal); }
        );

    /** Tracks the bottom-right point in this group of edges */
    private var bottom(default, null) = new Points<T>([]);

    /** Creates a new edge group from a list of edges */
    public function new () {}

    /**
     * Compares a point to the bottom-right most point already tracked. Replaces
     * that point with this one if this is further down right.
     */
    private function potentialBottomRight( point: T ) {
        if (
            bottom.length == 0 ||
            point.getY() == bottom[0].getY()
        ) {
            bottom.push(point);
        }
        else if ( point.getY() < bottom[0].getY() ) {
            bottom.clear();
            bottom.push(point);
        }
    }

    /** Adds an edge */
    public inline function add ( one: T, two: T ): EdgeGroup<T> {
        edges.add( new Edge( one, two ) );
        potentialBottomRight( one );
        potentialBottomRight( two );
        connections.get( one ).add( two );
        connections.get( two ).add( one );
        return this;
    }

    /** Picks the bottom right-most node in this group */
    public inline function bottomRight (): T {
        if ( bottom.length == 0 ) {
            throw "EdgeGroup does not have any points in it";
        }
        return bottom.last();
    }

    /** Picks the bottom left-most node in this group */
    public inline function bottomLeft (): T {
        if ( bottom.length == 0 ) {
            throw "EdgeGroup does not have any points in it";
        }
        return bottom[0];
    }

    /** Returns the connections to a point sorted by their angle */
    public inline function connected(
        point: T, sortVersus: T, direction: Direction
    ): AngleSort<T> {
        var points = connections.get(point).toArray();
        if ( points.length == 0 ) {
            throw "Point does not exist in EdgeGroup";
        }
        return new AngleSort(point, sortVersus, direction, points);
    }

    /** Removes an edge */
    public function remove( one: T, two: T ): Void {
        edges.remove( new Edge(one, two) );
        connections.get(one).remove(two);
        connections.get(two).remove(one);
    }

    /** Returns an array of all the edges in this group */
    public function toArray(): Array<Edge<T>> {
        return edges.toArray();
    }
}

