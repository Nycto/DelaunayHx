package;

import delaunay.DivideAndConquer;
import delaunay.RealPoint;
import massive.munit.Assert;

class DivideAndConquerTest {

    @Test public function testDedupe():Void {
        var points = [ new RealPoint(1, 2), new RealPoint(2, 1) ];
        Helper.arrayEquals( points, DivideAndConquer.dedupe(points) );

        Helper.arrayEquals(
            [ new RealPoint(1, 2), new RealPoint(2, 1) ],
            DivideAndConquer.dedupe([
                new RealPoint(1, 2), new RealPoint(2, 1),
                new RealPoint(1, 2), new RealPoint(2, 1)
            ])
        );
    }

    @Test public function testDedupeHashCodeConflict():Void {
        // The following points are crafted to cause a hashCode conflict
        var p1 = new RealPoint(0, 0);
        var p2 = new RealPoint(1, -41);
        Assert.areEqual( p1.hashCode(), p2.hashCode() );

        Helper.arrayEquals(
            [ p1, p2 ],
            DivideAndConquer.dedupe([ p1, p2, p1, p2 ])
        );
    }

}
