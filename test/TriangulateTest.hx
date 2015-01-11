package;

import delaunay.Set;
import delaunay.Triangulate;
import delaunay.DhxPoint;
import delaunay.RealPoint;
import delaunay.Edge;
import massive.munit.Assert;
import haxe.PosInfos;

class TriangulateTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    private function e (
        x1: Float, y1: Float,
        x2: Float, y2: Float
    ): Edge<RealPoint> {
        return new Edge( p(x1, y1), p(x2, y2) );
    }

    private function es ( from: RealPoint, to: Array<RealPoint> ) {
        return Lambda.array( Lambda.map(to, function (point) {
            return new Edge(from, point);
        }) );
    }

    private function flatten ( list: Array<Array<Edge<RealPoint>>> ) {
        return Lambda.fold(
            list,
            function ( edges, accum: Array<Edge<RealPoint>> ) {
                return accum.concat(edges);
            },
            []
        );
    }

    private function assertEdges (
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

    @Test public function testEmptyPoints():Void {
        assertEdges( [] );
    }

    @Test public function testOnePoint():Void {
        assertEdges( [], [ p(1, 5) ] );
    }

    @Test public function testTwoPoints():Void {
        assertEdges([ e(1, 5,  2, 5) ]);
    }

    @Test public function testThreePointsInATriangle():Void {
        assertEdges([ e(0, 0,  5, 5), e(5, 5,  10, 0), e(10, 0,  0, 0) ]);
    }

    @Test public function testThreePointsInALine():Void {
        assertEdges(
            [ e(0, 0,  5, 5), e(5, 5,  10, 10) ],
            [ p(0, 0), p(5, 5), p(10, 10) ]
        );

        assertEdges(
            [ e(0, 0,  5, 5), e(5, 5,  10, 10) ],
            [ p(0, 0), p(10, 10), p(5, 5) ]
        );

        assertEdges(
            [ e(0, 0,  5, 5), e(5, 5,  10, 10) ],
            [ p(5, 5), p(0, 0), p(10, 10) ]
        );
    }

    @Test public function testFour():Void {

        // Edges for the following grid:
        //
        // 2 |    *
        // 1 | *        *
        // 0 |    *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 1,  1, 0), e(0, 1,  1, 2),
            e(1, 0,  1, 2), e(1, 0,  3, 1),
            e(1, 2,  3, 1)
        ]);
    }

    @Test public function testComplex():Void {

        // Edges for the following grid:
        //
        // 3 |    *     *     *
        // 2 |    *        *
        // 1 | *     *        *
        // 0 |    *           *
        //   -------------------
        //     0  1  2  3  4  5

        assertEdges([
            e(0, 1,  1, 0), e(0, 1,  1, 2), e(0, 1,  1, 3),
            e(1, 0,  1, 2), e(1, 0,  2, 1), e(1, 0,  5, 0),
            e(1, 2,  2, 1), e(1, 2,  3, 3), e(1, 2,  1, 3),
            e(1, 3,  3, 3),
            e(2, 1,  5, 0), e(2, 1,  4, 2), e(2, 1,  3, 3),
            e(3, 3,  4, 2), e(3, 3,  5, 3),
            e(4, 2,  5, 0), e(4, 2,  5, 1), e(4, 2,  5, 3),
            e(5, 0,  5, 1),
            e(5, 1,  5, 3)
        ]);
    }

    @Test public function testLeftHigherThanRight():Void {
        // Edges for the following grid:
        //
        // 2 | *  *
        // 1 |
        // 0 |       *  *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 2,  1, 2), e(0, 2,  2, 0),
            e(1, 2,  2, 0), e(1, 2,  3, 0),
            e(2, 0,  3, 0)
        ]);
    }

    @Test public function testHorizontalGride():Void {
        // Edges for the following grid:
        //
        // 0 | *  *  *  *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 0,  1, 0),
            e(1, 0,  2, 0),
            e(2, 0,  3, 0)
        ]);
    }

    @Test public function testRightHigherThanLeft():Void {
        // Edges for the following grid:
        //
        // 2 |       *  *
        // 1 |
        // 0 | *  *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 0,  1, 0), e(0, 0,  2, 2),
            e(1, 0,  2, 2), e(1, 0,  3, 2),
            e(2, 2,  3, 2)
        ]);
    }

    @Test public function testVerticalLine():Void {
        // Edges for the following grid:
        //
        // 3 |    *
        // 2 |    *
        // 1 |    *
        // 0 |    *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(1, 0,  1, 1),
            e(1, 1,  1, 2),
            e(1, 2,  1, 3)
        ]);
    }

    @Test public function testDiagonalLine():Void {
        // Edges for the following grid:
        //
        // 3 |          *
        // 2 |       *
        // 1 |    *
        // 0 | *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 0,  1, 1),
            e(1, 1,  2, 2),
            e(2, 2,  3, 3)
        ]);
    }

    @Test public function testDeceptiveBaseEdge():Void {
        // Edges for the following grid:
        //
        // 2 | *     *
        // 1 | *
        // 0 | *
        //   -------------
        //     0  1  2  3

        assertEdges([
            e(0, 0,  0, 1), e(0, 0,  2, 2),
            e(0, 1,  0, 2), e(0, 1,  2, 2),
            e(0, 2,  2, 2)
        ]);
    }

    @Test public function testMergeFromNonBottom():Void {

        // Edges for the following grid:
        //
        // 3 |             *
        // 2 |       *
        // 1 |       *
        // 0 | *
        //   ----------------
        //     0  1  2  3  4

        assertEdges([
            e(0, 0,  2, 1), e(0, 0,  2, 2),
            e(2, 1,  2, 2), e(2, 1,  4, 3),
            e(2, 2,  4, 3)
        ]);
    }

    @Test public function testComplexWithFloatingPoints() {
        // These points were taken from here:
        // http://www.mathworks.com/help/matlab/math/voronoi-diagrams.html

        var x1 = p(-1.5, 3.2);
        var x2 = p(1.8, 3.3);
        var x3 = p(-3.7, 1.5);
        var x4 = p(-1.5, 1.3);
        var x5 = p(0.8, 1.2);
        var x6 = p(3.3, 1.5);
        var x7 = p(-4.0, -1.0);
        var x8 = p(-2.3, -0.7);
        var x9 = p(0, -0.5);
        var x10 = p(2.0, -1.5);
        var x11 = p(3.7, -0.8);
        var x12 = p(-3.5, -2.9);
        var x13 = p(-0.9, -3.9);
        var x14 = p(2.0, -3.5);
        var x15 = p(3.5, -2.25);

        assertEdges(flatten([
            es(x1, [ x3, x4, x5, x2 ]),
            es(x2, [ x1, x5, x6 ]),
            es(x3, [ x7, x8, x4, x1 ]),
            es(x4, [ x1, x5, x9, x8, x3 ]),
            es(x5, [ x2, x6, x10, x9, x4, x1 ]),
            es(x6, [ x11, x10, x5, x2 ]),
            es(x7, [ x3, x8, x12 ]),
            es(x8, [ x4, x9, x13, x12, x7, x3 ]),
            es(x9, [ x5, x10, x13, x8, x4 ]),
            es(x10, [ x6, x11, x15, x14, x13, x9, x5 ]),
            es(x11, [ x15, x10, x6 ]),
            es(x12, [ x8, x13, x7 ]),
            es(x13, [ x9, x10, x14, x12, x8 ]),
            es(x14, [ x10, x15, x13 ]),
            es(x15, [ x11, x14, x10 ])
        ]));
    }
}

