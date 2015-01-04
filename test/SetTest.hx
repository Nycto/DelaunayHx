package;

import delaunay.Set;
import massive.munit.Assert;

private typedef Id = { id: Int };
private typedef IdValue = { id: Int, value: Int };

class SetTest {

    private static function hash( value: Id ) {
        return value.id;
    }

    private static function idEqual( a: Id, b: Id ) {
        return a.id == b.id;
    }

    private static function equal( a: IdValue, b: IdValue ) {
        return a.value == b.value;
    }

    private static function compare( a: IdValue, b: IdValue ) {
        return a.value == b.value ? 0 : (a.value < b.value ? -1 : 1);
    }

    @Test public function testBasicFunctionality():Void {
        var hashset = new Set<Id>( hash, idEqual );

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
        var hashset = new Set<IdValue>( hash, equal );

        Assert.isFalse( hashset.contains({ id: 20, value: 50 }) );
        Assert.isFalse( hashset.contains({ id: 20, value: 90 }) );

        hashset.add({ id: 20, value: 50 });
        Assert.isTrue( hashset.contains({ id: 20, value: 50 }) );
        Assert.isFalse( hashset.contains({ id: 20, value: 90 }) );

        hashset.add({ id: 20, value: 90 });
        Assert.isTrue( hashset.contains({ id: 20, value: 50 }) );
        Assert.isTrue( hashset.contains({ id: 20, value: 90 }) );
    }

    @Test public function testRemove():Void {
        var hashset = new Set<IdValue>( hash, equal );

        hashset.add({ id: 20, value: 50 });
        hashset.add({ id: 20, value: 90 });
        hashset.add({ id: 40, value: 130 });

        Assert.isTrue( hashset.contains({ id: 20, value: 50 }) );
        Assert.isTrue( hashset.contains({ id: 20, value: 90 }) );
        Assert.isTrue( hashset.contains({ id: 40, value: 130 }) );

        hashset.remove({ id: 20, value: 50 });
        Assert.isFalse( hashset.contains({ id: 20, value: 50 }) );
        Assert.isTrue( hashset.contains({ id: 20, value: 90 }) );
        Assert.isTrue( hashset.contains({ id: 40, value: 130 }) );

        hashset.remove({ id: 40, value: 130 });
        Assert.isFalse( hashset.contains({ id: 20, value: 50 }) );
        Assert.isTrue( hashset.contains({ id: 20, value: 90 }) );
        Assert.isFalse( hashset.contains({ id: 40, value: 130 }) );
    }

    @Test public function testIteration():Void {
        var hashset = new Set<IdValue>( hash, equal );

        hashset.add({ id: 20, value: 50 });
        hashset.add({ id: 20, value: 90 });
        hashset.add({ id: 40, value: 130 });
        hashset.add({ id: 20, value: 50 });

        var result: Array<IdValue> = [];
        for ( value in hashset ) {
            result.push( value );
        }

        Helper.unsortedArrayEqualsUsing(
            [
                { id: 20, value: 50 },
                { id: 20, value: 90 },
                { id: 40, value: 130 }
            ],
            result,
            compare
        );
    }

    @Test public function testEmptyIteration():Void {
        var hashset = new Set<IdValue>( hash, equal );

        var result = [];
        for ( value in hashset ) {
            result.push( value );
        }

        Helper.arrayEqualsUsing( [], result, equal );
    }
}

