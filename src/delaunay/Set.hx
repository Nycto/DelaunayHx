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
}
