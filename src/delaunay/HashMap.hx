package delaunay;

import haxe.ds.IntMap;

/** A Key/Value tuple */
private class KeyValue<K, V> {
    public var key(default, null): K;
    public var value(default, null): V;
    public inline function new ( key: K, value: V ) {
        this.key = key;
        this.value = value;
    }
}

/**
 * Maps a key to a value using custom hash code and equality functions
 */
class HashMap<K, V> {

    /** Determines the hashcode of an object */
    private var hash: K -> Int;

    /** Determines whether two objects are equal */
    private var equal: K -> K -> Bool;

    /** The keys and values indexed by their hash map */
    private var objs = new IntMap<Array<KeyValue<K, V>>>();

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
    private inline function indexOf(
        list: Array<KeyValue<K, V>>, key: K
    ): Null<Int> {
        var result: Null<Int> = null;
        for ( index in 0...list.length ) {
            if ( this.equal(list[index].key, key) ) {
                result = index;
                break;
            }
        }
        return result;
    }

    /** Adds a value */
    public inline function set( key: K, value: V ): Void {
        var hashCode: Int = this.hash(key);

        var existing: Null<Array<KeyValue<K, V>>> = objs.get(hashCode);

        var representation = new KeyValue(key, value);

        if ( existing == null ) {
            objs.set( hashCode, [representation] );
        }
        else {
            var index: Null<Int> = indexOf( existing, key );
            if ( index == null ) {
                existing.push(representation);
            }
            else {
                existing[index] = representation;
            }
        }
    }

    /** Returns a value */
    public inline function get( key: K ): Null<V> {
        var hashCode: Int = this.hash(key);

        var existing: Null<Array<KeyValue<K, V>>> = objs.get(hashCode);

        if ( existing == null ) {
            return null;
        }
        else {
            var index: Null<Int> = indexOf( existing, key );
            return index == null ? null : existing[index].value;
        }
    }
}

