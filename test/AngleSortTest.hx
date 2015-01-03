package;

import delaunay.AngleSort;
import delaunay.RealPoint;
import massive.munit.Assert;

class AngleSortTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    @Test public function testClockwise():Void {
        var angleSort = new AngleSort(
            p(4, 0), p(1, 1),
            Clockwise,
            [ p(3, 10), p(3, 5), p(8, 4), p(1, 2) ]
        );

        Helper.iteratesTo(
            [ p(1, 2), p(3, 5), p(3, 10), p(8, 4) ],
            angleSort.iterator()
        );
    }

    @Test public function testCounterClockwise():Void {
        var angleSort = new AngleSort(
            p(1, 0), p(5, 1),
            CounterClockwise,
            [  p(1, 2), p(0, 1), p(2, 1) ]
        );

        Helper.iteratesTo(
            [ p(2, 1), p(1, 2), p(0, 1) ],
            angleSort.iterator()
        );
    }

    @Test public function testFullCircle():Void {
        var points = [
            p( 5, 1 ), p( 5, 5 ), p( 3, 5 ),
            p( 0, 5 ),
            p( -3, 5 ), p( -5, 5 ), p( -5, 1 ),
            p( -5, 0 ),
            p( -5, -1 ), p(-5, -5), p(-3, -5),
            p( 0, -5 ),
            p( 1, -5 ), p( 5, -5 ), p( 5, -3 )
        ];

        var counter = new AngleSort(
            p(0, 0), p(5, 0),
            CounterClockwise,
            points
        );
        Helper.iteratesTo( points, counter.iterator() );

        var clockwise = new AngleSort(
            p(0, 0), p(5, 0),
            Clockwise,
            points
        );
        points.reverse();
        Helper.iteratesTo( points, clockwise.iterator() );
    }
}

