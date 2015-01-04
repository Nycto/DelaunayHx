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
        if ( innerIter == null ) {
            return outerIter.hasNext();
        }
        else {
            return innerIter.hasNext() || outerIter.hasNext();
        }
    }

    /** Returns the next value in this iterator */
    public function next(): K {
        if ( innerIter == null || !innerIter.hasNext() ) {
            if ( !outerIter.hasNext() ) {
                throw "Iterator has already been exhausted";
            }
            innerIter = outerIter.next().iterator();
        }
        return innerIter.next();
    }
}


