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
        var group = new EdgeGroup<RealPoint>([]);

        group.add( e(0, 0,  4, 5) );
        group.add( e(5, 0,  4, 5) );
        group.add( e(0, -1,  4, 5) );
        group.add( e(5, 0,  4, 5) );

        Helper.unsortedArrayEquals(
            [
                e(0, 0,  4, 5),
                e(5, 0,  4, 5),
                e(0, -1,  4, 5)
            ],
            group.edges.toArray(),
            Edge.compare
        );
    }

    @Test public function testBottom():Void {
        var group = new EdgeGroup<RealPoint>([]);
        Helper.throws(group.bottomRight);
        Helper.throws(group.bottomLeft);

        group.add( e(1, 1,  4, 5) );
        Helper.equals( p(1, 1), group.bottomRight() );
        Helper.equals( p(1, 1), group.bottomLeft() );

        group.add( e(1, 0,  10, 4) );
        Helper.equals( p(1, 0), group.bottomRight() );
        Helper.equals( p(1, 0), group.bottomLeft() );

        group.add( e(2, 0,  1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );
        Helper.equals( p(1, 0), group.bottomLeft() );

        group.add( e(0, 0,  1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );
        Helper.equals( p(0, 0), group.bottomLeft() );
    }

    @Test public function testConnected():Void {
        var group = new EdgeGroup<RealPoint>([]);
        Helper.throws(function(){
            group.connected( p(1, 1), p(5, 1), CounterClockwise );
        });

        group.add( e(1, 1,  4, 5) );
        Helper.iteratesTo(
            [ p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );

        group.add( e(1, 1,  5, 5) );
        Helper.iteratesTo(
            [ p(5, 5), p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );

        group.add( e(8, 8,  5, 5) );
        Helper.iteratesTo(
            [ p(5, 5), p(4, 5) ],
            group.connected(p(1, 1), p(5, 1), CounterClockwise).iterator()
        );
    }
}

