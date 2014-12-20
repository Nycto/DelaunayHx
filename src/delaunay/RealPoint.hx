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
}

