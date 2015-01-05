package delaunay;

import delaunay.Slice;

/**
 * A phantom type that ensures a list of points is unique and sorted
 */
@:forward(iterator, toString, length)
abstract Points<T: DhxPoint>( Array<T> ) {

    /** Removes duplicates from a list of points */
    private static function dedupe<T: DhxPoint>( points: Array<T> ): Array<T> {
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

    /**
     * Compares two points to sort them left to right, bottom to top
     */
    public static function compare<T: DhxPoint>( a: T, b: T ): Int {
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
    }

    /** Constructor */
    public inline function new ( points: Array<T> ) {
        this = dedupe(points);
        this.sort( compare );
    }

    /** Convert from an array */
    @:from static public inline function fromArray<T: DhxPoint> (
        points: Array<T>
    ): Points<T> {
        return new Points( points );
    }

    /** Array accessor */
    @:arrayAccess public inline function get( index: Int ): T {
        return this[index];
    }

    /** Provides access to a part of this array */
    public inline function slice(): Slice<T> {
        return new SliceData(this, 0, this.length);
    }

    /** Adds a point to this list and re-sorts */
    public function push ( newPoint: T ): Void {
        // Make sure this point doesn't already exist in the list
        for ( point in this ) {
            if ( RealPoint.equal(point, newPoint) ) {
                return;
            }
        }
        this.push( newPoint );
        this.sort( compare );
    }

    /** Adds a bunch of points from another point set onto this one */
    public function addAll( other: Points<T> ): Void {
        var existing = new Set<T>( RealPoint.hash, RealPoint.equal );
        for ( point in this ) {
            existing.add(point);
        }
        for ( newPoint in other ) {
            if ( !existing.contains(newPoint) ) {
                this.push( newPoint );
            }
        }
        this.sort( compare );
    }

    /** Clears all values from this list */
    public function clear (): Void {
        this.splice(0, this.length);
    }

    /** Clears all values from this list */
    public function last (): T {
        if ( this.length == 0 ) {
            throw "Point list is empty";
        }
        return this[this.length - 1];
    }
}

