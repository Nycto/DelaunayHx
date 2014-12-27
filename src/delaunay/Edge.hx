package delaunay;

/** An edge between two points */
class Edge {

    /** The x coordinate */
    public var one(default, null): DhxPoint;

    /** The y coordinate */
    public var two(default, null): DhxPoint;

    /** Constructor */
    public inline function new ( one: DhxPoint, two: DhxPoint ) {
        this.one = one;
        this.two = two;
    }

    /** Determines whether this point equals another */
    public inline function equals( other: Edge ): Bool {
        if ( RealPoint.equal(one, other.one) ) {
            return RealPoint.equal(two, other.two);
        }
        else {
            return RealPoint.equal(two, other.one) &&
                RealPoint.equal(one, other.two);
        }
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


