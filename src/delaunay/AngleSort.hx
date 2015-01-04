package delaunay;

/**
 * A list of points sorted by their angle from an edge. During the merge
 * phase, these are the candidates for a new edge
 */
@:forward(iterator)
abstract AngleSort<T: DhxPoint>( Array<T> ) {

    /** Returns the angle between two vectors that share a base point */
    private static inline function angle(
        base: DhxPoint, a: DhxPoint, b: DhxPoint
    ) {
        var v1X = a.getX() - base.getX();
        var v1Y = a.getY() - base.getY();

        var v2X = b.getX() - base.getX();
        var v2Y = b.getY() - base.getY();

        // @TODO: This could probably be made faster by using a heuristic
        // instead of calling atan2. This page seems to have a few options:
        // http://stackoverflow.com/questions/16542042/fastest-way-to-sort-vectors-by-angle-without-actually-computing-that-angle
        var radians = Math.atan2(v2Y, v2X) - Math.atan2(v1Y, v1X);
        return radians >= 0 ? radians : 2 * Math.PI + radians;
    }

    /** Constructor */
    public inline function new (
        base: T,
        reference: T,
        direction: Direction,
        points: Array<T>
    ) {
        this = points;
        this.sort(function (a, b) {
            var angleToA = angle(base, reference, a);
            var angleToB = angle(base, reference, b);
            if ( angleToA == angleToB ) {
                return 0;
            }
            else if ( direction == Clockwise ) {
                return angleToA < angleToB ? 1 : -1;
            }
            else {
                return angleToA < angleToB ? -1 : 1;
            }
        });
    }
}
