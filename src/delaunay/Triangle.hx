package delaunay;

/**
 * A static set of operations
 */
class Triangle {

    /** A static class, so a private constructor */
    private function new () {}

    /** Returns the perpendicular slope for two points */
    public static inline function perpendicularSlope(
        a: DhxPoint, b: DhxPoint
    ): Float {
        return -1 * (a.getX() - b.getX()) / (a.getY() - b.getY());
    }

    /** Returns a point that is directly between two other points */
    public static inline function middle(
        a: DhxPoint, b: DhxPoint
    ): RealPoint {
        return new RealPoint(
            (a.getX() + b.getX()) / 2,
            (a.getY() + b.getY()) / 2
        );
    }

    /** In `y = mx + b`, solving for `b` */
    static inline function yIntersect(
        point: DhxPoint, slope: Float
    ): Float {
        return point.getY() - ( slope * point.getX() );
    }

    /** Returns the distance between two points */
    public static inline function distance( a: DhxPoint, b: DhxPoint ): Float {
        return Math.sqrt(
            Math.pow( b.getX() - a.getX(), 2 ) +
            Math.pow( b.getY() - a.getY(), 2 )
        );
    }

    /** Returns the circumcenter of a triangle */
    public static inline function circumcenter(
        a: DhxPoint, b: DhxPoint, c: DhxPoint
    ): RealPoint {

        // Calculate the line perpindicular to `a -> b`
        var ab_slope = perpendicularSlope(a, b);
        var ab_yInter = yIntersect(middle(a, b), ab_slope);

        // Calculate the line perpindicular to `b -> c`
        var bc_slope = perpendicularSlope(b, c);
        var bc_yInter = yIntersect(middle(b, c), bc_slope);

        // If the slopes are the same, it means they are parallel and these
        // three points don't form a triangle
        if ( ab_slope == bc_slope ) {
            throw "Given points don't form a triangle: " +
                a + ", " + b + ", " + c;
        }

        // y = m1 * x + b1
        // y = m2 * x + b2
        // m1 * x + b1 = m2 * x + b2
        // (m1 * x) - (m2 * x) = b2 - b1
        // x * (m1 - m2) = b2 - b1
        // x = (b2 - b1) / (m1 - m2)

        var centerX = (bc_yInter - ab_yInter) / (ab_slope - bc_slope);
        var centerY = ab_slope * centerX + ab_yInter;
        return new RealPoint( centerX, centerY );
    }

    /**
     * Determines whether a point is inside the circumcircle of a triangle
     * @param a A corner of the triangle
     * @param b A corner of the triangle
     * @param c A corner of the triangle
     * @param d The point being checked
     */
    public static inline function isPointInCircumCircle(
        a: DhxPoint, b: DhxPoint, c: DhxPoint, d: DhxPoint
    ): Bool {
        var center = circumcenter(a, b, c);
        return distance(d, center) < distance(a, center);
    }

}



