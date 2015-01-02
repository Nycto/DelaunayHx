package;

import delaunay.BuildingHashMap;
import massive.munit.Assert;

class BuildingHashMapTest {

    @Test public function testBasicFunctionality():Void {
        var hashmap = new BuildingHashMap<{ id: Int }, { value: String }>(
            function ( key ) { return key.id; },
            function ( a, b ) { return a.id == b.id; },
            function () { return { value: "Built!" }; }
        );

        Assert.areEqual( "Built!", hashmap.get({ id: 50 }).value );

        hashmap.set({ id: 50 }, { value: "Fifty" });
        Assert.areEqual( "Fifty", hashmap.get({ id: 50 }).value );

        hashmap.set({ id: 60 }, { value: "Sixty" });
        Assert.areEqual( "Sixty", hashmap.get({ id: 60 }).value );

        var value = hashmap.get({ id: 90 });
        Assert.areEqual( "Built!", value.value );
        value.value = "Something else";
        Assert.areEqual( "Something else", hashmap.get({ id: 90 }).value );
    }
}

