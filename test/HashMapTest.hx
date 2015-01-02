package;

import delaunay.HashMap;
import massive.munit.Assert;

class HashMapTest {

    @Test public function testBasicFunctionality():Void {
        var hashmap = new HashMap<{ id: Int }, String>(
            function ( key ) { return key.id; },
            function ( a, b ) { return a.id == b.id; }
        );

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
        var hashmap = new HashMap<{ hash: Int, value: Int }, String>(
            function ( obj ) { return obj.hash; },
            function ( a, b ) { return a.value == b.value; }
        );

        Assert.isNull( hashmap.get({ hash: 20, value: 50 }) );
        Assert.isNull( hashmap.get({ hash: 20, value: 90 }) );

        hashmap.set({ hash: 20, value: 50 }, "Fifty");
        Assert.areEqual( "Fifty", hashmap.get({ hash: 20, value: 50 }) );
        Assert.isNull( hashmap.get({ hash: 20, value: 90 }) );

        hashmap.set({ hash: 20, value: 90 }, "Ninety");
        Assert.areEqual( "Fifty", hashmap.get({ hash: 20, value: 50 }) );
        Assert.areEqual( "Ninety", hashmap.get({ hash: 20, value: 90 }) );
    }

    @Test public function testRemove():Void {
        var hashmap = new HashMap<{ hash: Int, value: Int }, String>(
            function ( obj ) { return obj.hash; },
            function ( a, b ) { return a.value == b.value; }
        );

        hashmap.set({ hash: 20, value: 50 }, "Fifty");
        hashmap.set({ hash: 20, value: 90 }, "Ninety");
        hashmap.set({ hash: 440, value: 10 }, "Ten");

        Assert.areEqual("Fifty", hashmap.get({ hash: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ hash: 20, value: 90 }));
        Assert.areEqual("Ten", hashmap.get({ hash: 440, value: 10 }));

        hashmap.unset({ hash: 20, value: 50 });
        Assert.isNull(hashmap.get({ hash: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ hash: 20, value: 90 }));
        Assert.areEqual("Ten", hashmap.get({ hash: 440, value: 10 }));

        hashmap.unset({ hash: 440, value: 10 });
        Assert.isNull(hashmap.get({ hash: 20, value: 50 }));
        Assert.areEqual("Ninety", hashmap.get({ hash: 20, value: 90 }));
        Assert.isNull(hashmap.get({ hash: 440, value: 10 }));

        hashmap.unset({ hash: 20, value: 90 });
        Assert.isNull(hashmap.get({ hash: 20, value: 50 }));
        Assert.isNull(hashmap.get({ hash: 20, value: 90 }));
        Assert.isNull(hashmap.get({ hash: 440, value: 10 }));
    }
}

