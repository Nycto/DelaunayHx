package;

import delaunay.Edge;
import delaunay.RealPoint;
import massive.munit.Assert;

class EdgeTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testOrdering():Void {
        Helper.equals( new Edge(p(1, 2), p(5, 5)).one, p(1, 2) );
        Helper.equals( new Edge(p(1, 2), p(5, 5)).two, p(5, 5) );

        Helper.equals( new Edge(p(5, 5), p(1, 2)).one, p(1, 2) );
        Helper.equals( new Edge(p(5, 5), p(1, 2)).two, p(5, 5) );
    }

    @Test public function testEquality():Void {
        Assert.isTrue(
            new Edge<RealPoint>( p(1, 2), p(5, 5) ).equals(
                new Edge<RealPoint>( p(1, 2), p(5, 5) ) ) );

        Assert.isTrue(
            new Edge<RealPoint>( p(5, 5), p(1, 2) ).equals(
                new Edge<RealPoint>( p(1, 2), p(5, 5) ) ) );

        Assert.isFalse(
            new Edge<RealPoint>( p(1, 2), p(5, 5) ).equals(
                new Edge<RealPoint>( p(1, 20), p(5, 5) ) ) );

        Assert.isFalse(
            new Edge<RealPoint>( p(5, 5), p(1, 2) ).equals(
                new Edge<RealPoint>( p(1, 20), p(5, 5) ) ) );
    }

    @Test public function testHashCode():Void {
        Assert.areEqual(
            new Edge<RealPoint>( p(1, 2), p(5, 5) ).hashCode(),
            new Edge<RealPoint>( p(1, 2), p(5, 5) ).hashCode()
        );

        Assert.areNotEqual(
            new Edge<RealPoint>( p(1, 2), p(5, 5) ).hashCode(),
            new Edge<RealPoint>( p(1, 2), p(5, 50) ).hashCode()
        );
    }

}

