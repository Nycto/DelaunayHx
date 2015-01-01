package;

import delaunay.Edge;
import delaunay.RealPoint;
import delaunay.Set;
import delaunay.Triangulate;

import massive.munit.Assert;
import haxe.PosInfos;

typedef Equals = {
    function equals( other: Dynamic ): Bool;
};

class Helper {

    /** Converts an iterator to an array */
    static public function toArray<T> ( input: Iterator<T> ): Array<T> {
        var out = [];
        for ( value in input ) {
            out.push(value);
        }
        return out;
    }

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

            equals( expected.next(), actual.next(), info );
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

    /** Determines whether this point equals another */
    static public function unsortedArrayEquals<T: Equals>(
        expected: Array<T>,
        actual: Array<T>,
        compare: T -> T -> Int,
        ?info: PosInfos
    ): Void {
        expected.sort( compare );
        actual.sort( compare );
        arrayEquals( expected, actual, info );
    }

    /** Determines whether this point equals another */
    static public function unsortedArrayEqualsUsing<T>(
        expected: Array<T>,
        actual: Array<T>,
        compare: T -> T -> Int,
        ?equals: T -> T -> Bool,
        ?info: PosInfos
    ): Void {
        expected.sort( compare );
        actual.sort( compare );
        if ( equals == null ) {
            equals = function (a, b) { return compare(a, b) == 0; }
        }
        arrayEqualsUsing( expected, actual, equals, info );
    }

    /** Asserts that a set of edges triangulates properly */
    public static function assertEdges (
        edges: Array<Edge<RealPoint>>,
        ?points: Array<RealPoint>,
        ?info: PosInfos
    ): Void {
        if ( points == null ) {
            points = new Array<RealPoint>();
            for ( edge in edges ) {
                points.push( edge.one );
                points.push( edge.two );
            }
        }

        var expected = new Set<Edge<RealPoint>>( Edge.hash, Edge.equal );
        Lambda.iter( edges, expected.add );

        var actual = new Set<Edge<RealPoint>>( Edge.hash, Edge.equal );
        Lambda.iter( new Triangulate(points).getEdges(), actual.add );

        var extra = Lambda.filter( actual, function ( edge ) {
            return !expected.contains(edge);
        });

        var missing = Lambda.filter( expected, function ( edge ) {
            return !actual.contains(edge);
        });

        if ( missing.length > 0 && extra.length == 0 ) {
            Assert.fail( "Missing edges: " + missing, info );
        }
        else if ( extra.length > 0 && missing.length == 0 ) {
            Assert.fail( "Extra edges: " + extra, info );
        }
        else if ( extra.length > 0 && missing.length > 0 ) {
            Assert.fail(
                "Missing edges: " + missing +
                " and extra edges: " + extra, info );
        }
    }

    /** Flattens a list of edges */
    public static function flatten ( list: Array<Array<Edge<RealPoint>>> ) {
        return Lambda.fold(
            list,
            function ( edges, accum: Array<Edge<RealPoint>> ) {
                return accum.concat(edges);
            },
            []
        );
    }
}

