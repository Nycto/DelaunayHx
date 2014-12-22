package;

import massive.munit.Assert;
import haxe.PosInfos;

typedef Equals = {
    function equals( other: Dynamic ): Bool;
};

class Helper {

    /** Determines whether this point equals another */
    static public function arrayEquals<T: Equals>(
        expected: Array<T>,
        actual: Array<T>,
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
            if ( !expected[i].equals( actual[i] ) ) {
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
        catch ( err: Dynamic ) {}
    }
}

