package;

import delaunay.Edge;
import delaunay.RealPoint;
import massive.munit.Assert;

class EdgeTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testEquality():Void {
        Assert.isTrue(
            new Edge( p(1, 2), p(5, 5) ).equals(
                new Edge( p(1, 2), p(5, 5) ) ) );

        Assert.isTrue(
            new Edge( p(5, 5), p(1, 2) ).equals(
                new Edge( p(1, 2), p(5, 5) ) ) );

        Assert.isFalse(
            new Edge( p(1, 2), p(5, 5) ).equals(
                new Edge( p(1, 20), p(5, 5) ) ) );

        Assert.isFalse(
            new Edge( p(5, 5), p(1, 2) ).equals(
                new Edge( p(1, 20), p(5, 5) ) ) );
    }

}

