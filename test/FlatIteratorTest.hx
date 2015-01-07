package;

import delaunay.FlatIterator;
import massive.munit.Assert;

class FlatIteratorTest {

    private static function equals ( a: Int, b: Int ) {
        return a == b;
    }

    @Test public function testEmptyIterator():Void {
        Helper.arrayEqualsUsing(
            [],
            Helper.toArray(
                new FlatIterator<Int>([].iterator())
            ),
            equals
        );
    }

    @Test public function testBasicIteration():Void {
        Helper.arrayEqualsUsing(
            [1, 2, 3, 4, 5, 6],
            Helper.toArray(new FlatIterator<Int>([
                [1, 2, 3], [4, 5, 6]
            ].iterator())),
            equals
        );
    }

    @Test public function testEmptySections():Void {
        Helper.arrayEqualsUsing(
            [1, 2, 3, 4, 5, 6],
            Helper.toArray(new FlatIterator<Int>([
                [], [], [1, 2, 3], [], [], [], [4, 5, 6], []
            ].iterator())),
            equals
        );
    }

    @Test public function testOnlyEmptySections():Void {
        Helper.arrayEqualsUsing(
            [],
            Helper.toArray(new FlatIterator<Int>([
                [], [], [], [], [], [], []
            ].iterator())),
            equals
        );
    }
}

