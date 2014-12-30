package;

import delaunay.Points;
import delaunay.Slice;
import delaunay.RealPoint;
import massive.munit.Assert;

class SliceTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testSliceCreation():Void {
        var points: Points<RealPoint> = [ p(5, 2), p(2, 1), p(1, 2), p(0, 0) ];
        var slice = points.slice();

        Helper.iteratorsEqual(points.iterator(), slice.iterator());

        Helper.arrayEquals(
            [ points[1], points[2] ],
            points.slice().slice(1, 2).toArray()
        );
    }

    @Test public function testSliceAccess():Void {
        var points: Points<RealPoint> = [ p(5, 2), p(2, 1), p(1, 2), p(0, 0) ];
        var slice = points.slice().slice(1, 2);

        Assert.areEqual(points[1], slice[0]);
        Assert.areEqual(points[2], slice[1]);

        Helper.throws(function() { trace(slice[2]); });
        Helper.throws(function() { trace(slice[-1]); });
    }

    @Test public function testSliceOutOfRange():Void {
        var slice: Slice<RealPoint> = [ p(5, 2), p(2, 1), p(1, 2), p(0, 0) ];

        Helper.throws(function() { slice.slice(-1, 3); });
        Helper.throws(function() { slice.slice(4, 0); });
        Helper.throws(function() { slice.slice(2, 3); });
    }

    @Test public function testSliceIteration():Void {
        var slice: Slice<RealPoint> = [ p(0, 0), p(1, 2), p(2, 1), p(5, 2) ];

        var output = new Array<RealPoint>();

        for ( point in slice.slice(1, 3) ) {
            output.push(point);
        }

        Helper.arrayEquals([ p(1, 2), p(2, 1), p(5, 2) ], output);
    }

}

