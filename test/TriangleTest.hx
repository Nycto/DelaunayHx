package;

import delaunay.Triangle;
import delaunay.RealPoint;
import massive.munit.Assert;

class TriangleTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testIsPointInCircumcircle():Void {

        // Points in a line can't form a triangle
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

        Assert.isFalse(Triangle.isPointInCircumCircle(
            p(0, 0), p(100, 1), p(200, -10), p(5, 2)
        ));

        Assert.isTrue(Triangle.isPointInCircumCircle(
            p(0, 0), p(100, 1), p(200, -10), p(100, -300)
        ));

        // A point that lies ON the circumcircle should not be considered
        // within it
        Assert.isFalse(Triangle.isPointInCircumCircle(
            p(0, 0), p(0, 1), p(1, 1), p(1, 0)
        ));
    }
}


