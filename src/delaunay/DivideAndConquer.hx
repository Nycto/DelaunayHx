package delaunay;

/**
 * Performs a Delaunay Triangulation on a set of points
 */
class DivideAndConquer {

    /** Finds the candidate for a group */
    public static function findCandidate<T: DhxPoint>(
        group: EdgeGroup<T>, anchor: T, reference: T, points: AngleSort<T>
    ): Null<T> {
        var iter = points.iterator();

        if ( !iter.hasNext() ) {
            return null;
        }

        var point = iter.next();
        for ( next in iter ) {

            var isInCircle = Triangle.isPointInCircumCircle(
                anchor, reference, point, next );

            if ( isInCircle ) {
                group.remove( anchor, point );
                point = next;
            }
            else {
                break;
            }
        }

        return point;
    }

    /** Merges together sets of edges */
    public static function mergeWithBase<T: DhxPoint>(
        left: EdgeGroup<T>, right: EdgeGroup<T>, baseLeft: T, baseRight: T
    ): Void {

        var leftCandidate = findCandidate(
            left, baseLeft, baseRight,
            left.connected(baseLeft, baseRight, CounterClockwise)
        );

        var rightCandidate = findCandidate(
            right, baseRight, baseLeft,
            right.connected(baseRight, baseLeft, Clockwise)
        );

        left.add( baseLeft, baseRight );

        // Without candidates, there is nothing to merge
        if ( rightCandidate == null && leftCandidate == null ) {
            return;
        }

        // If there are candidates on the left but not the right
        else if ( rightCandidate == null ) {
            mergeWithBase( left, right, leftCandidate, baseRight );
        }

        // If there are candidates on the right but not the left
        else if ( leftCandidate == null ) {
            mergeWithBase( left, right, baseLeft, rightCandidate );
        }

        // If the right candidate is within the circumcircle of the left
        // candidate, then the right candidate is the one we choose
        else if ( Triangle.isPointInCircumCircle(
            baseLeft, baseRight, leftCandidate, rightCandidate
        ) ) {
            mergeWithBase( left, right, baseLeft, rightCandidate );
        }

        // The only remaining option is that the left candidate is the one
        else {
            mergeWithBase( left, right, leftCandidate, baseRight );
        }
    }

    /** Merges together sets of edges */
    public static function merge<T: DhxPoint>(
        left: EdgeGroup<T>, right: EdgeGroup<T>
    ): EdgeGroup<T> {
        var baseLeft = left.bottomRight();
        var baseRight = right.bottomLeft();

        mergeWithBase(left, right, baseLeft, baseRight);
        left.addAll( right );

        return left;
    }
}


