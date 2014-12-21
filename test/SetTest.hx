package;

import delaunay.Set;
import massive.munit.Assert;

class SetTest {

    @Test public function testBasicFunctionality():Void {
        var hashset = new Set<{ id: Int }>(
            function ( obj ) { return obj.id; },
            function ( a, b ) { return a.id == b.id; }
        );

        Assert.isFalse( hashset.contains({ id: 50 }) );
        hashset.add({ id: 50 });
        Assert.isTrue( hashset.contains({ id: 50 }) );

        hashset.add({ id: 50 });
        Assert.isTrue( hashset.contains({ id: 50 }) );

        Assert.isFalse( hashset.contains({ id: 90 }) );
        hashset.add({ id: 90 });
        Assert.isTrue( hashset.contains({ id: 90 }) );
    }

    @Test public function testHashCodeConflicts():Void {
        var hashset = new Set<{ hash: Int, value: Int }>(
            function ( obj ) { return obj.hash; },
            function ( a, b ) { return a.value == b.value; }
        );

        Assert.isFalse( hashset.contains({ hash: 20, value: 50 }) );
        Assert.isFalse( hashset.contains({ hash: 20, value: 90 }) );

        hashset.add({ hash: 20, value: 50 });
        Assert.isTrue( hashset.contains({ hash: 20, value: 50 }) );
        Assert.isFalse( hashset.contains({ hash: 20, value: 90 }) );

        hashset.add({ hash: 20, value: 90 });
        Assert.isTrue( hashset.contains({ hash: 20, value: 50 }) );
        Assert.isTrue( hashset.contains({ hash: 20, value: 90 }) );
    }

}
