package delaunay;

/** A concrete Point for those times when you don't want to define your own */
class RealPoint implements DhxPoint {

    /** The x coordinate */
    private var x: Float;

    /** The y coordinate */
    private var y: Float;

    /** Constructor */
    public function new ( x: Float, y: Float ) {
        this.x = x;
        this.y = y;
    }

    /** Returns the X coordinate */
    public inline function getX(): Float {
        return x;
    }

    /** Returns the Y coordinate */
    public inline function getY(): Float {
        return y;
    }

    /** Generates a hash code for a point */
    public static inline function hash ( pnt: DhxPoint ): Int {
        return 41 * (41 + Std.int(pnt.getX())) + Std.int(pnt.getY());
    }

    /** Determines whether two points are equal */
    public static inline function equal ( a: DhxPoint, b: DhxPoint ): Bool {
        return a.getX() == b.getX() && a.getY() == b.getY();
    }

    /** Determines whether this point equals another */
    public function equals( other: DhxPoint ): Bool {
        return equal( this, other );
    }

    /** Generates a hash code for a point */
    public function hashCode (): Int {
        return hash(this);
    }
}

