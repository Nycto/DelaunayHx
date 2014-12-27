package delaunay;

/**
 * A static set of operations
 */
class Triangle {

    /** A static class, so a private constructor */
    private function new () {}

    /**
     * Determines whether three points form a triangle. The only way this
     * returns false is if they form a line
     * @param a A corner of the triangle
     * @param b A corner of the triangle
     * @param c A corner of the triangle
     */
    public static inline function isTriangle(
        a: DhxPoint, b: DhxPoint, c: DhxPoint
    ): Bool {
        var x1 = a.getX();
        var y1 = a.getY();

        var x2 = b.getX();
        var y2 = b.getY();

        var x3 = c.getX();
        var y3 = c.getY();

        return (y2 - y1) * (x3 - x2) != (y3 - y2) * (x2 - x1);
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

        var x1 = a.getX();
        var y1 = a.getY();

        var x2 = b.getX();
        var y2 = b.getY();

        var x3 = c.getX();
        var y3 = c.getY();

        var x4 = d.getX();
        var y4 = d.getY();

        // For the line perpendicular to the first two points, calculate `m`
        // and `b` in the equation `y = mx + b`
        var slope1 = -1 * ( (x2 - x1) / (y2 - y1) );
        var yintercept1 = ( -1 * slope1 * (x1 + x2) + y1 + y2 ) / 2;

        // For the line perpendicular to the second and third points, calculate
        // `m` and `b` in the equation `y = mx + b`
        var slope2 = -1 * ( (x3 - x2) / (y3 - y2) );
        var yintercept2 = ( -1 * slope2 * (x2 + x3) + y2 + y3 ) / 2;

        // If the slopes are the same, it means the lines are parallel and these
        // three points don't form a triangle
        if ( slope1 == slope2 ) {
            throw "Given points don't form a triangle: " +
                a + ", " + b + ", " + c;
        }

        // (centerx, centery) is the centroid of the circumcircle
        var centerx = (yintercept2 - yintercept1) / (slope1 - slope2);
        var centery = (slope1 * centerx) + yintercept1;

        // The radius of the circumcircle
        var radius = ( (centerx - x1) * (centerx - x1) ) +
            ( (centery - y1) * (centery - y1) );

        // The distance of the point being checked from the centroid
        var distance = ( (centerx - x4) * (centerx - x4) ) +
            ( (centery - y4) * (centery - y4) );

        // If the distance is less than the radius, the point is in the circle.
        // Note that we consider points on the circumference to be outside
        // of the circumcircle
        return distance < radius;
    }
}


