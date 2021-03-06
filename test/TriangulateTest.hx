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

    @Test public function testEmptyPoints():Void {
        Helper.assertEdges( [] );
    }

    @Test public function testOnePoint():Void {
        Helper.assertEdges( [], [ p(1, 5) ] );
    }

    @Test public function testTwoPoints():Void {
        Helper.assertEdges([ e(1, 5,  2, 5) ]);
    }

    @Test public function testThreePointsInATriangle():Void {
        Helper.assertEdges([
            e(0, 0,  5, 5), e(5, 5,  10, 0), e(10, 0,  0, 0)
        ]);
    }

    @Test public function testThreePointsInALine():Void {
        Helper.assertEdges(
            [ e(0, 0,  5, 5), e(5, 5,  10, 10) ],
            [ p(0, 0), p(5, 5), p(10, 10) ]
        );

        Helper.assertEdges(
            [ e(0, 0,  5, 5), e(5, 5,  10, 10) ],
            [ p(0, 0), p(10, 10), p(5, 5) ]
        );

        Helper.assertEdges(
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

        Helper.assertEdges([
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

        Helper.assertEdges([
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

        Helper.assertEdges([
            e(0, 2,  1, 2), e(0, 2,  2, 0),
            e(1, 2,  2, 0), e(1, 2,  3, 0),
            e(2, 0,  3, 0)
        ]);
    }

    @Test public function testTieForBottom():Void {

        // Edges for the following grid:
        //
        // 2 |       *  *  *
        // 1 |
        // 0 | *  *  *
        //   ----------------
        //     0  1  2  3  4

        Helper.assertEdges([
            e(0, 0,  1, 0), e(0, 0,  2, 2),
            e(1, 0,  2, 0), e(1, 0,  2, 2),
            e(2, 0,  2, 2), e(2, 0,  3, 2), e(2, 0,  4, 2),
            e(2, 2,  3, 2),
            e(3, 2,  4, 2)
        ]);
    }

    @Test public function testHorizontalGride():Void {
        // Edges for the following grid:
        //
        // 0 | *  *  *  *
        //   -------------
        //     0  1  2  3

        Helper.assertEdges([
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

        Helper.assertEdges([
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

        Helper.assertEdges([
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

        Helper.assertEdges([
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

        Helper.assertEdges([
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

        Helper.assertEdges([
            e(0, 0,  2, 1), e(0, 0,  2, 2),
            e(2, 1,  2, 2), e(2, 1,  4, 3),
            e(2, 2,  4, 3)
        ]);
    }

    @Test public function testReconsiderRightBaseEdge () {
        // Edges for the following grid:
        //
        // 4 |             *
        // 3 |
        // 2 |          *
        // 1 |          *
        // 0 | *
        //   ----------------
        //     0  1  2  3  4

        Helper.assertEdges([
            e(0, 0,  3, 1), e(0, 0,  3, 2), e(0, 0,  4, 4),
            e(3, 1,  3, 2), e(3, 1,  4, 4),
            e(3, 2,  4, 4)
        ]);
    }
}

