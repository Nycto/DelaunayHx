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

    /** Determines whether this point equals another */
    public inline function equals( other: Edge<T> ): Bool {
        return RealPoint.equal(one, other.one) &&
            RealPoint.equal(two, other.two);
    }

    /** Converts this point to a readable string */
    public inline function toString(): String {
        return "Edge(" + one + " -> " + two + ")";
    }

    /** Generates a hash code */
    public inline function hashCode (): Int {
        return 41 * (41 + RealPoint.hash(one)) + RealPoint.hash(two);
    }
}


