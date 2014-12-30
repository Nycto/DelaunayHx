package delaunay;

/** The data representing a slice */
class SliceData<T: DhxPoint> {
    public var data(default, null): Array<T>;
    public var start(default, null): Int;
    public var end(default, null): Int;
    public function new ( data: Array<T>, start: Int, length: Int ) {
        this.data = data;
        this.start = start;
        this.end = start + length;
    }
}

/** The interface representing a slice of a Point list */
abstract Slice<T: DhxPoint> ( SliceData<T> ) from SliceData<T> {

    /** Convert from an array */
    @:from static public inline function fromArray<T: DhxPoint> (
        points: Array<T>
    ): Slice<T> {
        return new Points(points).slice();
    }

    /** Array length */
    public inline function length(): Int {
        return this.end - this.start;
    }

    /** Array accessor */
    @:arrayAccess public inline function get( index: Int ): T {
        var actual = this.start + index;
        if ( index < 0 || actual >= this.end ) {
            throw "Index out of bounds: " + index;
        }
        return this.data[actual];
    }

    /** Iteration */
    public function iterator(): Iterator<T> {
        var offset = this.start;
        return {
            hasNext: function (): Bool {
                return offset < this.end;
            },
            next: function (): T {
                return this.data[offset++];
            }
        };
    }

    /** Provides access to a part of this array */
    public inline function slice( start: Int, len: Int ): Slice<T> {
        if ( start < 0 || start >= length() ) {
            throw "Slice starting index out of bounds: " + start;
        }
        else if ( start + len > length() ) {
            throw "Slice length out of bounds: " + len;
        }
        return new SliceData(this.data, this.start + start, len);
    }

    /** Converts this slice to an array */
    public inline function toArray(): Array<T> {
        var output = new Array<T>();
        for ( point in iterator() ) {
            output.push(point);
        }
        return output;
    }

    /** Returns whether this slice can be split */
    public inline function canSplit(): Bool {
        return length() >= 4;
    }

    /** Divides this slice into two and returns the left side */
    public inline function splitLeft (): Slice<T> {
        if ( !canSplit() ) {
            throw "Slice is too small to split";
        }
        return slice(0, Math.ceil(length() / 2));
    }

    /** Divides this slice into two and returns the left side */
    public inline function splitRight (): Slice<T> {
        if ( !canSplit() ) {
            throw "Slice is too small to split";
        }
        var halfway = length() / 2;
        return slice( Math.ceil(halfway), Math.floor(halfway) );
    }
}

