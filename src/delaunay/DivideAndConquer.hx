package delaunay;

/**
 * A static set of operations
 */
class DivideAndConquer {

    /** A static class, so a private constructor */
    private function new () {}

    /** Removes duplicates from a list of points */
    public static function dedupe<T: DhxPoint>( points: Array<T> ): Array<T> {
        var output = new Array<T>();

        var seen = new Set<DhxPoint>( RealPoint.hash, RealPoint.equal );

        for ( point in points ) {
            if ( !seen.contains( point ) ) {
                output.push( point );
                seen.add( point );
            }
        }

        return output;
    }

    /** Performs an in-place sort of the points */
    public static function sort<T: DhxPoint>( points: Array<T> ): Array<T> {
        points.sort(function (a, b): Int {
            var aX = a.getX();
            var bX = b.getX();
            if ( aX < bX ) {
                return -1;
            }
            else if ( aX > bX ) {
                return 1;
            }
            else {
                var aY = a.getY();
                var bY = b.getY();
                return aY < bY ? -1 : (aY > bY ? 1 : 0);
            }
        });
        return points;
    }

}


