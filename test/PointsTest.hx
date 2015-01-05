package;

import delaunay.Points;
import delaunay.RealPoint;
import massive.munit.Assert;

class PointsTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testDedupe():Void {
        var points = [ p(1, 2), p(2, 1) ];
        Helper.iteratesTo( points, new Points(points).iterator() );

        Helper.iteratesTo(
            [ p(1, 2), p(2, 1) ],
            new Points([ p(1, 2), p(2, 1), p(1, 2), p(2, 1) ]).iterator()
        );
    }

    @Test public function testDedupeHashCodeConflict():Void {
        // The following points are crafted to cause a hashCode conflict
        var p1 = p(0, 0);
        var p2 = p(1, -41);
        Assert.areEqual( p1.hashCode(), p2.hashCode() );

        Helper.iteratesTo(
            [ p1, p2 ],
            new Points([ p1, p2, p1, p2 ]).iterator()
        );
    }

    @Test public function testSort():Void {
        Helper.iteratesTo(
            [ p(0, 5), p(3, 3), p(5, 1) ],
            new Points([ p(5, 1), p(3, 3), p(0, 5) ]).iterator()
        );

        Helper.iteratesTo(
            [ p(0, 1), p(0, 3), p(0, 5) ],
            new Points([ p(0, 5), p(0, 1), p(0, 3) ]).iterator()
        );

        Helper.iteratesTo(
            [
                p(0, 1), p(1, 0), p(1, 2), p(1, 3), p(2, 1),
                p(3, 3), p(4, 2), p(5, 0), p(5, 1), p(5, 3)
            ],
            new Points([
                p(4, 2), p(5, 3), p(2, 1), p(0, 1), p(5, 0),
                p(3, 3), p(5, 1), p(1, 2), p(1, 0), p(1, 3)
            ]).iterator()
        );
    }

    @Test public function testPointsPhantomType():Void {
        var points: Points<RealPoint> = [ p(1, 2), p(2, 1), p(1, 2), p(0, 0) ];
        Assert.areEqual( 3, points.length );
        Helper.equals( p(0, 0), points[0] );
        Helper.equals( p(1, 2), points[1] );
        Helper.equals( p(2, 1), points[2] );
    }

    @Test public function testPush():Void {
        var points = new Points<RealPoint>([]);
        Helper.iteratesTo([], points.iterator());

        points.push( p(5, 5) );
        Helper.iteratesTo([ p(5, 5) ], points.iterator());

        points.push( p(0, 0) );
        Helper.iteratesTo([ p(0, 0), p(5, 5) ], points.iterator());

        points.push( p(0, 0) );
        Helper.iteratesTo([ p(0, 0), p(5, 5) ], points.iterator());

        points.push( p(5, 10) );
        Helper.iteratesTo([ p(0, 0), p(5, 5), p(5, 10) ], points.iterator());
    }

    @Test public function testClear():Void {
        var points = new Points([ p(1, 2), p(2, 1), p(1, 2), p(0, 0) ]);
        points.clear();
        Helper.iteratesTo([], points.iterator());
    }

    @Test public function testLast():Void {
        var points = new Points([ p(1, 2), p(2, 1), p(1, 2), p(0, 0) ]);
        Helper.equals( p(2, 1), points.last() );

        Helper.throws(function() { new Points([]).last(); });
    }

    @Test public function testAddAll():Void {
        var points = new Points([]);

        points.addAll( new Points([ p(1, 2), p(2, 1) ]) );
        Helper.iteratesTo([ p(1, 2), p(2, 1) ], points.iterator());

        points.addAll( new Points([ p(0, 0), p(1, 2), p(5, 5) ]) );
        Helper.iteratesTo(
            [ p(0, 0), p(1, 2), p(2, 1), p(5, 5) ],
            points.iterator()
        );
    }

}

