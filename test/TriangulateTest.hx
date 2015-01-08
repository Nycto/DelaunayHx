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
}

