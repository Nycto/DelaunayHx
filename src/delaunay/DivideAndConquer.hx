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

}


