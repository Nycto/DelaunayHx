package;

import delaunay.Triangle;
import delaunay.RealPoint;
import massive.munit.Assert;

class TriangleTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testPerpendicularSlope():Void {
        Assert.areEqual(-1, Triangle.perpendicularSlope( p(0, 0), p(1, 1) ));
        Assert.areEqual(-0.5, Triangle.perpendicularSlope( p(0, 0), p(2, 4) ));
    }

    @Test public function testMiddle():Void {
        Helper.equals( p(0, 1), Triangle.middle(p(0, 0), p(0, 2)) );
        Helper.equals( p(1, 0), Triangle.middle(p(0, 0), p(2, 0)) );
        Helper.equals( p(2.5, 2.5), Triangle.middle(p(1, 1), p(4, 4)) );
    }

    @Test public function testDistance():Void {
        Assert.areEqual( 2, Triangle.distance(p(0, 0), p(0, 2)) );
        Assert.areEqual( 2, Triangle.distance(p(0, 0), p(2, 0)) );
        Assert.areEqual( Math.sqrt(18), Triangle.distance(p(1, 1), p(4, 4)) );
    }

    @Test public function testCircumcenter():Void {
        Helper.throws(function () {
            Triangle.circumcenter( p(0, 0), p(5, 5), p(10, 10) );
        });

        Helper.equals(
            p(73/46, -7/46),
            Triangle.circumcenter( p(2, 3), p(3, -3), p(-1, -2) )
        );
    }

    @Test public function testIsPointInCircumcircle():Void {
        Helper.throws(function () {
            Triangle.isPointInCircumCircle(
                p(0, 0), p(5, 5), p(10, 10), p(5, 2) );
        });

        Assert.isTrue(Triangle.isPointInCircumCircle(
            p(0, 0), p(5, 5), p(10, 0), p(5, 2)
        ));

        Assert.isFalse(Triangle.isPointInCircumCircle(
            p(0, 0), p(5, 5), p(10, 0), p(50, 2)
        ));

        // A point that lies ON the circumcircle should not be considered
        // within it
        Assert.isFalse(Triangle.isPointInCircumCircle(
            p(0, 0), p(0, 1), p(1, 1), p(1, 0)
        ));
    }
}


