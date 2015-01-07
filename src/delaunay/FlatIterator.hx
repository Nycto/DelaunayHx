package delaunay;

/**
 * An iterator that flattens out an iterator that contains iterators
 */
class FlatIterator<K> {

    /**
     * The outer iterator
     */
    private var outerIter: Iterator<Iterable<K>>;

    /**
     * The inner iterator
     */
    private var innerIter: Null<Iterator<K>> = null;

    /** Constructor */
    public function new ( outer: Iterator<Iterable<K>> ) {
        this.outerIter = outer;
    }

    /** Returns whether there are values left in this iterator */
    public function hasNext(): Bool {
        while ( innerIter == null || !innerIter.hasNext() ) {
            if ( !outerIter.hasNext() ) {
                return false;
            }
            else {
                innerIter = outerIter.next().iterator();
            }
        }
        return innerIter.hasNext();
    }

    /** Returns the next value in this iterator */
    public function next(): K {
        if ( innerIter == null || !innerIter.hasNext() ) {
            throw "Iterator has already been exhausted";
        }
        return innerIter.next();
    }
}


