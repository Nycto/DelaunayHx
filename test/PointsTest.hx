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
        Helper.arrayEquals( points, Points.dedupe(points) );

        Helper.arrayEquals(
            [ p(1, 2), p(2, 1) ],
            Points.dedupe([
                p(1, 2), p(2, 1), p(1, 2), p(2, 1)
            ])
        );
    }

    @Test public function testDedupeHashCodeConflict():Void {
        // The following points are crafted to cause a hashCode conflict
        var p1 = p(0, 0);
        var p2 = p(1, -41);
        Assert.areEqual( p1.hashCode(), p2.hashCode() );

        Helper.arrayEquals(
            [ p1, p2 ],
            Points.dedupe([ p1, p2, p1, p2 ])
        );
    }

    @Test public function testSort():Void {
        Helper.arrayEquals(
            [ p(0, 5), p(3, 3), p(5, 1) ],
            Points.sort([
                p(5, 1), p(3, 3), p(0, 5)
            ])
        );

        Helper.arrayEquals(
            [ p(0, 1), p(0, 3), p(0, 5) ],
            Points.sort([
                p(0, 5), p(0, 1), p(0, 3)
            ])
        );

        Helper.arrayEquals(
            [
                p(0, 1), p(1, 0), p(1, 2), p(1, 3), p(2, 1),
                p(3, 3), p(4, 2), p(5, 0), p(5, 1), p(5, 3)
            ],
            Points.sort([
                p(4, 2), p(5, 3), p(2, 1), p(0, 1), p(5, 0),
                p(3, 3), p(5, 1), p(1, 2), p(1, 0), p(1, 3)
            ])
        );
    }

    @Test public function testPointsPhantomType():Void {
        var points: Points<RealPoint> = [ p(1, 2), p(2, 1), p(1, 2), p(0, 0) ];
        Assert.areEqual( 3, points.length() );
        Helper.equals( p(0, 0), points[0] );
        Helper.equals( p(1, 2), points[1] );
        Helper.equals( p(2, 1), points[2] );
    }
}

