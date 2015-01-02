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

    @Test public function testBottomRight():Void {
        var group = new EdgeGroup<RealPoint>([]);
        Helper.throws(group.bottomRight);

        group.add( e(1, 1,  4, 5) );
        Helper.equals( p(1, 1), group.bottomRight() );

        group.add( e(1, 0,  10, 4) );
        Helper.equals( p(1, 0), group.bottomRight() );

        group.add( e(2, 0,  1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );

        group.add( e(0, 0,  1, 9) );
        Helper.equals( p(2, 0), group.bottomRight() );
    }
}

