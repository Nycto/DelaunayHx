package delaunay;

/**
 * A static set of operations
 */
class Triangle {

    /** A static class, so a private constructor */
    private function new () {}

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

        var midx1 = (x1 + x2) / 2;
        var midy1 = (y1 + y2) / 2;
        var slope1 = -1 * ( (x2 - x1) / (y2 - y1) );
        var yintercept1 = midy1 - ( slope1 * midx1 );

        var  midx2 = (x2 + x3) / 2;
        var  midy2 = (y2 + y3) / 2;
        var  slope2 = -1 * ( (x3 - x2) / (y3 - y2) );
        var  yintercept2 = midy2 - ( slope2 * midx2 );

        // If the slopes are the same, it means they are parallel and these
        // three points don't form a triangle
        if ( slope1 == slope2 ) {
            throw "Given points don't form a triangle: " +
                a + ", " + b + ", " + c;
        }

        var centerx = (yintercept2 - yintercept1) / (slope1 - slope2);
        var centery = (slope1 * centerx) + yintercept1;

        var radius = ( (centerx - x1) * (centerx - x1) ) +
            ( (centery - y1) * (centery - y1) );

        var distance = ( (centerx - x4) * (centerx - x4) ) +
            ( (centery - y4) * (centery - y4) );

        return distance < radius;
    }

}


