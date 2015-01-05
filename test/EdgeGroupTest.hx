package;

import delaunay.Edge;
import delaunay.EdgeGroup;
import delaunay.RealPoint;
import massive.munit.Assert;

class EdgeGroupTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    private function e (
        x1: Float, y1: Float,
        x2: Float, y2: Float
    ): Edge<RealPoint> {
        return new Edge( p(x1, y1), p(x2, y2) );
    }

    @Test public function testAddEdge():Void {
        var group = new EdgeGroup<RealPoint>();

        group.add( p(0, 0), p(4, 5) );
        group.add( p(5, 0), p(4, 5) );
        group.add( p(0, -1), p(4, 5) );
        group.add( p(5, 0), p(4, 5) );

        Helper.unsortedArrayEquals(
            [
                e(0, 0,  4, 5),
                e(5, 0,  4, 5),
                e(0, -1,  4, 5)
            ],
            group.toArray(),
            Edge.compare
        );
    }

    @Test public function testBottom():Void {
        var group = new EdgeGroup<RealPoint>();
        Helper.throws(group.bottomRight);
        Helper.throws(group.bottomLeft);

        group.add( p(1, 1), p(4, 5) );
        Helper.equals( p(1, 1), group.bottomRight() );
        Helper.equals( p(1, 1), group.bottomLeft() );

        group.add( p(1, 0), p(10, 4) );
        Helper.equals( p(1, 0), group.bottomRight() );
        Helper.equals( p(1, 0), group.bottomLeft() );

        group.add( p(2, 0), p(1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );
        Helper.equals( p(1, 0), group.bottomLeft() );

        group.add( p(0, 0), p(1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );
        Helper.equals( p(0, 0), group.bottomLeft() );
    }

    @Test public function testConnected():Void {
        var group = new EdgeGroup<RealPoint>();
        Helper.throws(function(){
            group.connected( p(1, 1), p(5, 1), CounterClockwise );
        });

        group.add( p(1, 1), p(4, 5) );
        Helper.iteratesTo(
            [ p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );

        group.add( p(1, 1), p(5, 5) );
        Helper.iteratesTo(
            [ p(5, 5), p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );

        group.add( p(8, 8), p(5, 5) );
        Helper.iteratesTo(
            [ p(5, 5), p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );
    }

    @Test public function testRemove():Void {
        var group = new EdgeGroup<RealPoint>();

        group.add( p(1, 1), p(4, 5) );
        group.add( p(1, 1), p(5, 5) );
        group.add( p(8, 8), p(5, 5) );

        group.remove( p(1, 1), p(5, 5) );

        Helper.iteratesTo(
            [ p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );

        Helper.iteratesTo(
            [ p(8, 8) ],
            group.connected(p(5, 5), p(5, 1), CounterClockwise).iterator()
        );
    }

    @Test public function testAddAllWithoutSharedPoints():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 0), p(2, 0) )
            .add( p(1, 1), p(2, 0) )
            .add( p(0, 0), p(1, 1) );

        group.addAll(
            new EdgeGroup<RealPoint>()
                .add( p(5, 5), p(7, 5) )
                .add( p(6, 6), p(7, 5) )
                .add( p(5, 5), p(6, 6) )
        );

        Helper.unsortedArrayEquals(
            [
                e(0, 0,  2, 0), e(1, 1,  2, 0), e(0, 0,  1, 1),
                e(5, 5,  7, 5), e(6, 6,  7, 5), e(5, 5,  6, 6)
            ],
            group.toArray(),
            Edge.compare
        );

        Helper.equals( p(2, 0), group.bottomRight() );
        Helper.equals( p(0, 0), group.bottomLeft() );
    }

    @Test public function testAddAllWithSharedPoints():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 0), p(2, 0) )
            .add( p(1, 1), p(2, 0) )
            .add( p(0, 0), p(1, 1) );

        group.addAll(
            new EdgeGroup<RealPoint>()
                .add( p(1, 1), p(2, 0) )
                .add( p(1, 1), p(5, 5) )
                .add( p(5, 5), p(2, 0) )
        );

        Helper.unsortedArrayEquals(
            [
                e(0, 0,  2, 0), e(1, 1,  2, 0), e(0, 0,  1, 1),
                e(1, 1,  5, 5), e(5, 5,  2, 0)
            ],
            group.toArray(),
            Edge.compare
        );
    }

    @Test public function testAddAllWithNewBottom():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 5), p(2, 5) )
            .add( p(1, 5), p(2, 5) );

        group.addAll(
            new EdgeGroup<RealPoint>()
                .add( p(1, 2), p(1, 4) )
                .add( p(3, 3), p(5, 2) )
        );

        Helper.unsortedArrayEquals(
            [
                e(0, 5,  2, 5), e(1, 5,  2, 5),
                e(1, 2,  1, 4), e(3, 3,  5, 2)
            ],
            group.toArray(),
            Edge.compare
        );

        Helper.equals( p(5, 2), group.bottomRight() );
        Helper.equals( p(1, 2), group.bottomLeft() );
    }

    @Test public function testAddAllWithSharedBottom():Void {
        var group = new EdgeGroup<RealPoint>()
            .add( p(0, 5), p(2, 7) )
            .add( p(3, 5), p(2, 7) );

        group.addAll(
            new EdgeGroup<RealPoint>()
                .add( p(1, 5), p(1, 8) )
                .add( p(5, 5), p(1, 8) )
        );

        Helper.equals( p(5, 5), group.bottomRight() );
        Helper.equals( p(0, 5), group.bottomLeft() );
    }
}

