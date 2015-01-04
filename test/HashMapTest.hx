package;

import delaunay.HashMap;
import massive.munit.Assert;

class HashMapTest {

    private static function hash( value: { id: Int } ) {
        return value.id;
    }

    private static function idEqual( a: {id: Int}, b: {id: Int} ) {
        return a.id == b.id;
    }

    private static function equal( a: {value: Int}, b: {value: Int} ) {
        return a.value == b.value;
    }

    private static function compare( a: {id: Int}, b: {id: Int} ) {
        return a.id == b.id ? 0 : (a.id < b.id ? -1 : 1);
    }

    @Test public function testBasicFunctionality():Void {
        var hashmap = new HashMap<{ id: Int }, String>( hash, idEqual );

        Assert.isNull( hashmap.get({ id: 50 }) );

        hashmap.set({ id: 50 }, "Fifty");
        Assert.areEqual( "Fifty", hashmap.get({ id: 50 }) );

        hashmap.set({ id: 50 }, "Fifty is 50");
        Assert.areEqual( "Fifty is 50", hashmap.get({ id: 50 }) );

        hashmap.set({ id: 60 }, "Sixty");
        Assert.areEqual( "Sixty", hashmap.get({ id: 60 }) );
        Assert.areEqual( "Fifty is 50", hashmap.get({ id: 50 }) );

        Assert.isNull( hashmap.get({ id: 90 }) );
    }

    @Test public function testHashCodeConflicts():Void {
        var hashmap = new HashMap<{ id: Int, value: Int }, String>(hash, equal);

        Assert.isNull( hashmap.get({ id: 20, value: 50 }) );
        Assert.isNull( hashmap.get({ id: 20, value: 90 }) );

        hashmap.set({ id: 20, value: 50 }, "Fifty");
        Assert.areEqual( "Fifty", hashmap.get({ id: 20, value: 50 }) );
        Assert.isNull( hashmap.get({ id: 20, value: 90 }) );

        hashmap.set({ id: 20, value: 90 }, "Ninety");
        Assert.areEqual( "Fifty", hashmap.get({ id: 20, value: 50 }) );
        Assert.areEqual( "Ninety", hashmap.get({ id: 20, value: 90 }) );
    }

    @Test public function testRemove():Void {
        var hashmap = new HashMap<{ id: Int, value: Int }, String>(hash, equal);

        hashmap.set({ id: 20, value: 50 }, "Fifty");
        hashmap.set({ id: 20, value: 90 }, "Ninety");
        hashmap.set({ id: 440, value: 10 }, "Ten");

        Assert.areEqual("Fifty", hashmap.get({ id: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ id: 20, value: 90 }));
        Assert.areEqual("Ten", hashmap.get({ id: 440, value: 10 }));

        hashmap.unset({ id: 20, value: 50 });
        Assert.isNull(hashmap.get({ id: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ id: 20, value: 90 }));
        Assert.areEqual("Ten", hashmap.get({ id: 440, value: 10 }));

        hashmap.unset({ id: 440, value: 10 });
        Assert.isNull(hashmap.get({ id: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ id: 20, value: 90 }));
        Assert.isNull(hashmap.get({ id: 440, value: 10 }));

        hashmap.unset({ id: 20, value: 90 });
        Assert.isNull(hashmap.get({ id: 20, value: 50 }));
        Assert.isNull(hashmap.get({ id: 20, value: 90 }));
        Assert.isNull(hashmap.get({ id: 440, value: 10 }));
    }

    @Test public function testKeyIteration():Void {
        var hashmap = new HashMap<{ id: Int }, String>( hash, idEqual );

        Helper.arrayEqualsUsing(
            [],
            Helper.toArray( hashmap.keys() ),
            idEqual
        );

        hashmap.set({ id: 50 }, "Fifty");
        hashmap.set({ id: 60 }, "Sixty");
        hashmap.set({ id: 90 }, "Ninety");

        Helper.unsortedArrayEqualsUsing(
            [{ id: 50 }, { id: 60 }, { id: 90 }],
            Helper.toArray( hashmap.keys() ),
            compare
        );
    }
}

