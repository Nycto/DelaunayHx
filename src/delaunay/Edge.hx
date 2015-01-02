package delaunay;

/** An edge between two points */
class Edge<T: DhxPoint> {

    /** The x coordinate */
    public var one(default, null): T;

    /** The y coordinate */
    public var two(default, null): T;

    /** Constructor */
    public inline function new ( one: T, two: T ) {
        // The points of an edge should always be ordered from left to right,
        // bottom to top
        if ( Points.compare(one, two) <= 0 ) {
            this.one = one;
            this.two = two;
        }
        else {
            this.one = two;
            this.two = one;
        }
    }

    /** Compares two edges for sorting */
    public static function compare<T: DhxPoint>(a: Edge<T>, b: Edge<T>): Int {
        return Points.compare(a.one, b.one) != 0
            ? Points.compare(a.one, b.one)
            : Points.compare(a.two, b.two);
    }

    /** Determines whether this point equals another */
    public static inline function equal<T: DhxPoint>(
        a: Edge<T>, b: Edge<T>
    ): Bool {
        return RealPoint.equal(a.one, b.one) &&
            RealPoint.equal(a.two, b.two);
    }

    /** Generates a hash code */
    public static inline function hash<T: DhxPoint> ( edge: Edge<T> ): Int {
        return 41 * (41 + RealPoint.hash(edge.one)) + RealPoint.hash(edge.two);
    }

    /** Converts this point to a readable string */
    public inline function toString(): String {
        return "Edge(" + one + " -> " + two + ")";
    }

    /** Determines whether this point equals another */
    public inline function equals( other: Edge<T> ): Bool {
        return equal( this, other );
    }

    /** Generates a hash code for a point */
    public inline function hashCode (): Int {
        return hash(this);
    }
}


