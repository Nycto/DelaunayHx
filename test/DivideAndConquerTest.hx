package;

import delaunay.DhxPoint;
import delaunay.RealPoint;
import delaunay.EdgeGroup;
import delaunay.Edge;
import delaunay.AngleSort;
import delaunay.DivideAndConquer;
import massive.munit.Assert;
import haxe.PosInfos;

class DivideAndConquerTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    private function e (
        x1: Float, y1: Float,
        x2: Float, y2: Float
    ): Edge<RealPoint> {
        return new Edge( p(x1, y1), p(x2, y2) );
    }

    @Test public function testFindCandidateWithoutPoints():Void {
        Assert.isNull(
            DivideAndConquer.findCandidate(
                new EdgeGroup<RealPoint>(),
                p(0, 0), p(5, 0),
                new AngleSort( p(0, 0), p(5, 0), Clockwise, [] )
            )
        );
    }

    @Test public function testFindCandidateOnePoint():Void {
        Helper.equals(
            p(1, 10),
            DivideAndConquer.findCandidate(
                new EdgeGroup<RealPoint>(),
                p(0, 0), p(5, 0),
                new AngleSort(
                    p(0, 0), p(5, 0), CounterClockwise,
                    [ p(1, 10) ]
                )
            )
        );
    }

    @Test public function testFindCandidateFirstPointIsCorrect():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 0), p(1, 10) )
            .add( p(0, 0), p(0, 10) )
            .add( p(0, 0), p(-4, 2) );

        Helper.equals(
            p(1, 10),
            DivideAndConquer.findCandidate(
                group, p(0, 0), p(5, 0),
                new AngleSort(
                    p(0, 0), p(5, 0), CounterClockwise,
                    [ p(1, 10), p(0, 10), p(-4, 2) ]
                )
            )
        );

        Helper.unsortedArrayEquals(
            [ e(0, 0,  1, 10), e(0, 0,  0, 10), e(0, 0,  -4, 2) ],
            group.toArray(),
            Edge.compare
        );
    }

    @Test public function testFindCandidateRejectedPoints():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 0), p(2, 7) )
            .add( p(0, 0), p(1, 5) )
            .add( p(0, 0), p(0, 3) )
            .add( p(0, 0), p(-1, 2) );

        Helper.equals(
            p(0, 3),
            DivideAndConquer.findCandidate(
                group, p(0, 0), p(4, 0),
                new AngleSort(
                    p(0, 0), p(5, 0), CounterClockwise,
                    [ p(2, 7), p(1, 5), p(0, 3), p(-1, 2) ]
                )
            )
        );

        Helper.unsortedArrayEquals(
            [ e(0, 0,  0, 3), e(0, 0,  -1, 2) ],
            group.toArray(),
            Edge.compare
        );
    }

    @Test public function testFindCandidate180Degrees():Void {
        Assert.isNull(
            DivideAndConquer.findCandidate(
                new EdgeGroup<RealPoint>(),
                p(0, 0), p(4, 0),
                new AngleSort(p(0, 0), p(5, 0), CounterClockwise, [ p(-9, 0) ])
            )
        );

        Assert.isNull(
            DivideAndConquer.findCandidate(
                new EdgeGroup<RealPoint>(),
                p(0, 0), p(4, 0),
                new AngleSort(p(0, 0), p(5, 0), CounterClockwise, [ p(-9, -1) ])
            )
        );
    }

    @Test public function testSimpleMerge():Void {
        var left = new EdgeGroup<RealPoint>().add( p(0, 0), p(0, 3) );
        var right = new EdgeGroup<RealPoint>().add( p(4, 0), p(4, 6) );
        DivideAndConquer.merge( left, right );

        Helper.unsortedArrayEquals(
            [
                e(0, 0,  0, 3), e(4, 0,  4, 6),
                e(0, 0,  4, 0),
                e(0, 3,  4, 0),
                e(0, 3,  4, 6)
            ],
            left.toArray(),
            Edge.compare
        );
    }

    public static function assertPoints( left: RealPoint, right: RealPoint ) {
        return function ( actualLeft: RealPoint, actualRight: RealPoint ) {
            Helper.equals( left, actualLeft );
            Helper.equals( right, actualRight );
        }
    }

    @Test public function testChooseBases():Void {

        // Even ground
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>().add( p(0, 0), p(2, 0) ),
            new EdgeGroup<RealPoint>().add( p(4, 0), p(6, 0) ),
            assertPoints( p(2, 0), p(4, 0) )
        );

        // The left side is slightly higher than the right side
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>().add( p(0, 2), p(2, 2) ),
            new EdgeGroup<RealPoint>().add( p(4, 0), p(6, 0) ),
            assertPoints( p(0, 2), p(4, 0) )
        );

        // Right is slightly higher than left
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>().add( p(0, 0), p(2, 0) ),
            new EdgeGroup<RealPoint>().add( p(4, 4), p(6, 4) ),
            assertPoints( p(2, 0), p(6, 4) )
        );

        // Left slope continues in a concave direction
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>()
                .add( p(0, 4), p(1, 2) )
                .add( p(1, 2), p(5, 1) ),
            new EdgeGroup<RealPoint>().add( p(6, 0), p(8, 0) ),
            assertPoints( p(1, 2), p(6, 0) )
        );

        // Right slope continues in a concave direction
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>().add( p(0, 0), p(2, 0) ),
            new EdgeGroup<RealPoint>()
                .add( p(3, 1), p(7, 2) )
                .add( p(7, 2), p(8, 4) ),
            assertPoints( p(2, 0), p(7, 2) )
        );

        // Starting point is on same slope with right point
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>()
                .add( p(0, 0), p(1, 1) )
                .add( p(1, 1), p(2, 2) ),
            new EdgeGroup<RealPoint>()
                .add( p(3, 3), p(4, 4) )
                .add( p(4, 4), p(5, 5) ),
            assertPoints( p(2, 2), p(3, 3) )
        );

        // Vertical join
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>()
                .add( p(0, 0), p(0, 1) )
                .add( p(0, 1), p(0, 2) ),
            new EdgeGroup<RealPoint>()
                .add( p(0, 3), p(0, 4) )
                .add( p(0, 4), p(0, 5) ),
            assertPoints( p(0, 2), p(0, 3) )
        );

        // Vertical left side with horizontal right side
        DivideAndConquer.chooseBases(
            new EdgeGroup<RealPoint>().add( p(0, 0), p(0, 1) ),
            new EdgeGroup<RealPoint>().add( p(0, 2), p(2, 2) ),
            assertPoints( p(0, 0), p(2, 2) )
        );
    }
}


