package;

import massive.munit.Assert;
import haxe.PosInfos;

typedef Equals = {
    function equals( other: Dynamic ): Bool;
};

class Helper {

    /** Determines whether this point equals another */
    static public function arrayEqualsUsing<T>(
        expected: Array<T>,
        actual: Array<T>,
        equals: T -> T -> Bool,
        ?info: PosInfos
    ): Void {
        if ( expected.length != actual.length ) {
            Assert.fail(
                "Array lengths should be the same. " +
                "Expected: " + expected.length + ", " +
                "Actual: " + actual.length,
                info
            );
        }

        for (i in 0...expected.length) {
            if ( !equals(expected[i], actual[i]) ) {
                Assert.fail(
                    "Expected values to be the same at offset: " + i + ". " +
                    "Expected: " + expected + ", " +
                    "Actual: " + actual,
                    info
                );
            }
        }
    }

    /** Determines whether this point equals another */
    static public function arrayEquals<T: Equals>(
        expected: Array<T>,
        actual: Array<T>,
        ?info: PosInfos
    ): Void {
        arrayEqualsUsing(
            expected, actual,
            function (a, b) { return a.equals(b); },
            info
        );
    }

    /** Determines whether this point equals another */
    static public function equals<T: Equals>(
        expected: T,
        actual: T,
        ?info: PosInfos
    ): Void {
        if ( !expected.equals( actual ) ) {
            Assert.fail(
                "Expected " + expected + ", but was " + actual,
                info
            );
        }
    }

    /** Determines whether this point equals another */
    static public function throws(
        callback: Void -> Void, ?info: PosInfos
    ): Void {
        try {
            callback();
            Assert.fail("Expected an exception, but none was thrown", info);
        }
        catch ( err: massive.munit.AssertionException ) {
            throw err;
        }
        catch ( err: Dynamic ) {}
    }


    /** Determines whether this point equals another */
    static public function iteratorsEqual<T: Equals>(
        expected: Iterator<T>,
        actual: Iterator<T>,
        ?info: PosInfos
    ): Void {
        while (true) {
            var expHasNext = expected.hasNext();
            var actHasNext = actual.hasNext();

            if ( expHasNext && !actHasNext ) {
                Assert.fail("Iterator ran out of values early", info);
            }
            else if ( !expHasNext && actHasNext ) {
                Assert.fail("Iterator has too many values", info);
            }
            else if ( !expHasNext && !expHasNext ) {
                return;
            }

            equals( expected.next(), actual.next() );
        }
    }

    /** Determines whether an iterator equals an array */
    static public function iteratesTo<T: Equals>(
        expected: Array<T>,
        actual: Iterator<T>,
        ?info: PosInfos
    ): Void {
        var offset: Int = 0;
        iteratorsEqual(
            {
                hasNext: function (): Bool {
                    return offset < expected.length;
                },
                next: function (): T {
                    offset++;
                    return expected[offset - 1];
                }
            },
            actual,
            info
        );
    }
}

