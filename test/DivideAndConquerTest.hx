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

    @Test public function testChooseBaseLeft():Void {
        // Even ground
        Helper.equals(
            p(2, 2),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>().add( p(0, 2), p(2, 2) ),
                p(4, 2)
            )
        );

        // The left side is slightly higher than the right side
        Helper.equals(
            p(0, 4),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>()
                    .add( p(0, 4), p(4, 3) )
                    .add( p(7, 2), p(5, 4) )
                    .add( p(4, 3), p(7, 2) ),
                p(8, 0)
            )
        );

        // Right is slightly higher than left
        Helper.equals(
            p(1, 0),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(1, 0) ),
                p(4, 4)
            )
        );

        // Cut off when the slope goes in the wrong direction
        Helper.equals(
            p(1, 2),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>()
                    .add( p(0, 4), p(1, 2) )
                    .add( p(1, 2), p(5, 1) ),
                p(6, 0)
            )
        );

        // Starting point is on same slope with right point
        Helper.equals(
            p(2, 2),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(1, 1) )
                    .add( p(1, 1), p(2, 2) )
                    .add( p(0, 0), p(-1, 1) ),
                p(3, 3)
            )
        );

        // Vertical starting lines
        Helper.equals(
            p(0, 2),
            DivideAndConquer.chooseBaseLeft(
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(0, 1) )
                    .add( p(0, 1), p(0, 2) ),
                p(0, 5)
            )
        );
    }

    @Test public function testChooseBaseRight():Void {

        // Even ground
        Helper.equals(
            p(0, 0),
            DivideAndConquer.chooseBaseRight(
                p(-5, 0),
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(1, 0) )
                    .add( p(1, 0), p(2, 0) )
            )
        );

        // Left higher than right
        Helper.equals(
            p(0, 0),
            DivideAndConquer.chooseBaseRight(
                p(-2, 5),
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(1, 0) )
                    .add( p(1, 0), p(2, 0) )
            )
        );

        // Right higher than left
        Helper.equals(
            p(2, 0),
            DivideAndConquer.chooseBaseRight(
                p(-2, -5),
                new EdgeGroup<RealPoint>()
                    .add( p(0, 0), p(1, 0) )
                    .add( p(1, 0), p(2, 0) )
            )
        );

        // Stop with the slop changes unfavorably
        Helper.equals(
            p(5, 2),
            DivideAndConquer.chooseBaseRight(
                p(0, 0),
                new EdgeGroup<RealPoint>()
                    .add( p(1, 1), p(5, 2) )
                    .add( p(5, 2), p(6, 4) )
            )
        );

        // Vertical starting edge
        Helper.equals(
            p(5, 5),
            DivideAndConquer.chooseBaseRight(
                p(0, 0),
                new EdgeGroup<RealPoint>().add( p(0, 5), p(5, 5) )
            )
        );
    }
}


