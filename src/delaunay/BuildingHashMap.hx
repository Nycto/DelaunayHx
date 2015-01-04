package delaunay;

/**
 * Maps a key to a value and builds a new value when fetching one that
 * doesn't yet exist
 */
class BuildingHashMap<K, V> {

    /** The inner hash map */
    private var inner: HashMap<K, V>;

    /** Builds a new value */
    private var build: Void -> V;

    /**
     * Constructor
     * @param hashCode Generates a hash for an object
     * @param equals Determines whether two objects are equal
     * @param build Builds a new value
     */
    public inline function new(
        hash: K -> Int,
        equal: K -> K -> Bool,
        build: Void -> V
    ) {
        this.inner = new HashMap(hash, equal);
        this.build = build;
    }

    /** Adds a value */
    public inline function set( key: K, value: V ): Void {
        inner.set(key, value);
    }

    /** Returns a value */
    public inline function get( key: K ): V {
        var value = inner.get(key);
        if ( value == null ) {
            var built = build();
            inner.set(key, built);
            return built;
        }
        else {
            return value;
        }
    }

    /** Returns a value or null if the key doesn't exist */
    public inline function maybeGet( key: K ): Null<V> {
        return inner.get(key);
    }

    /** Returns an iterator of the keys in this map */
    public inline function keys(): Iterator<K> {
        return inner.keys();
    }

    /** Returns a string representation of this hashmap */
    public function toString(): String {
        return inner.toString();
    }
}


