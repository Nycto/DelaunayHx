package;

import delaunay.DivideAndConquer;
import delaunay.RealPoint;
import massive.munit.Assert;

class DivideAndConquerTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testDedupe():Void {
        var points = [ p(1, 2), p(2, 1) ];
        Helper.arrayEquals( points, DivideAndConquer.dedupe(points) );

        Helper.arrayEquals(
            [ p(1, 2), p(2, 1) ],
            DivideAndConquer.dedupe([
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
            DivideAndConquer.dedupe([ p1, p2, p1, p2 ])
        );
    }

    @Test public function testSort():Void {
        Helper.arrayEquals(
            [ p(0, 5), p(3, 3), p(5, 1) ],
            DivideAndConquer.sort([
                p(5, 1), p(3, 3), p(0, 5)
            ])
        );

        Helper.arrayEquals(
            [ p(0, 1), p(0, 3), p(0, 5) ],
            DivideAndConquer.sort([
                p(0, 5), p(0, 1), p(0, 3)
            ])
        );

        Helper.arrayEquals(
            [
                p(0, 1), p(1, 0), p(1, 2), p(1, 3), p(2, 1),
                p(3, 3), p(4, 2), p(5, 0), p(5, 1), p(5, 3)
            ],
            DivideAndConquer.sort([
                p(4, 2), p(5, 3), p(2, 1), p(0, 1), p(5, 0),
                p(3, 3), p(5, 1), p(1, 2), p(1, 0), p(1, 3)
            ])
        );
    }

}

