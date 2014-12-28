package delaunay;

/**
 * A phantom type that ensures a list of points is unique and sorted
 */
abstract Points<T: DhxPoint>( Array<T> ) {

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

    /** Constructor */
    public inline function new ( points: Array<T> ) {
        this = sort( dedupe(points) );
    }

    /** Convert from an array */
    @:from static public inline function fromArray<T: DhxPoint> (
        points: Array<T>
    ): Points<T> {
        return new Points( points );
    }

    /** Convert this list a string */
    public inline function toString(): String {
        return this.toString();
    }

    /** Array length */
    public inline function length(): Int {
        return this.length;
    }

    /** Array accessor */
    @:arrayAccess public inline function get( index: Int ): T {
        return this[index];
    }
}

