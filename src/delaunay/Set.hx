package delaunay;

import haxe.ds.IntMap;

/**
 * A set of objects
 */
class Set<K> {

    /** The map of objects indexed by their hashcode */
    private var objs = new IntMap<List<K>>();

    /** Determines the hashcode of an object */
    private var hash: K -> Int;

    /** Determines whether two objects are equal */
    private var equal: K -> K -> Bool;

    /**
     * Constructor
     * @param hashCode Generates a hash for an object
     * @param equals Determines whether two objects are equal
     */
    public inline function new( hash: K -> Int, equal: K -> K -> Bool ) {
        this.hash = hash;
        this.equal = equal;
    }

    /** Determines whether a List contains a specific item */
    private inline function listContains( list: List<K>, item: K ): Bool {
        var result: Bool = false;
        for ( element in list ) {
            if ( this.equal(element, item) ) {
                result = true;
                break;
            }
        }
        return result;
    }

    /** Adds a value */
    public inline function add( value: K ): Void {
        var hashCode = this.hash(value);
        var existing = objs.get(hashCode);
        if ( existing == null ) {
            var newList = new List();
            newList.add(value);
            objs.set( hashCode, newList );
        }
        else if ( !listContains(existing, value) ) {
            existing.add(value);
        }
    }

    /** Determines whether this set contains a value */
    public inline function contains( value: K ): Bool {
        var existing = objs.get(this.hash(value));
        return existing == null ? false : listContains(existing, value);
    }

    /** Generates an iterator */
    public function iterator(): Iterator<K> {
        return new SetIterator<K>( objs );
    }

    /** Converts this set to an array */
    public function toArray(): Array<K> {
        var result = new Array<K>();
        for ( value in iterator() ) {
            result.push( value );
        }
        return result;
    }
}

/**
 * An iterator for walking through the values in a set
 */
private class SetIterator<K> {

    /**
     * Iterataion requires walking through each list of values in the map. This
     * is the outer map iterator.
     */
    private var mapIter: Iterator<List<K>>;

    /**
     * An iterator for each list from the values in the Map
     */
    private var listIter: Null<Iterator<K>> = null;

    /** Constructor */
    public function new ( map: IntMap<List<K>> ) {
        mapIter = map.iterator();
    }

    /** Returns whether there are values left in this iterator */
    public function hasNext(): Bool {
        if ( listIter == null && mapIter.hasNext() ) {
            return mapIter.hasNext();
        }
        else {
            return listIter.hasNext() || mapIter.hasNext();
        }
    }

    /** Returns the next value in this iterator */
    public function next(): K {
        if ( listIter == null || !listIter.hasNext() ) {
            if ( !mapIter.hasNext() ) {
                throw "Iterator has already been exhausted";
            }
            listIter = mapIter.next().iterator();
        }
        return listIter.next();
    }
}

