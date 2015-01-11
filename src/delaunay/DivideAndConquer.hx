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

    /**
     * Chooses the baseLeft point for a new merge
     * @param group - The group to pull edges from
     * @param direction - The direction to sort pulled edges
     * @param best - The best point seen so far
     * @param examine - The next point to examine
     * @param reference - The reference point from the other side of the merge
     */
    private static function chooseBase<T: DhxPoint>(
        group: EdgeGroup<T>, direction: Direction,
        examine: T, reference: T
    ): T {

        var examineY = examine.getY();
        var rise = reference.getY() - examineY;

        // If we see a horizontal line, both right and left are on even ground
        if ( rise == 0 ) {
            return examine;
        }

        var option = group.connected(examine, reference, direction).first();

        // No more options? Guess this is it...
        if ( option == null ) {
            return examine;
        }

        var examineX = examine.getX();
        var run = reference.getX() - examineX;

        // If we see a vertical line, we need to look for more points
        if ( run == 0 ) {
            return chooseBase( group, direction, option, reference );
        }

        var slope = rise / run;
        var optionSlope =
            (option.getY() - examineY) / (option.getX() - examineX);

        // If the next point is an extension of this point, we need to keep
        // looking further
        if ( slope == optionSlope ) {
            return chooseBase( group, direction, option, reference );
        }

        // If the next point is concave, we want to use the current point
        else if ( direction == Clockwise && optionSlope < slope ) {
            return examine;
        }
        else if ( direction == CounterClockwise && optionSlope > slope ) {
            return examine;
        }

        else {
            return chooseBase( group, direction, option, reference );
        }
    }

    /** Returns the base point for the left group */
    public static function chooseBaseLeft<T: DhxPoint>(
        left: EdgeGroup<T>, right: T
    ): T {
        return chooseBase(left, Clockwise, left.bottomRight(), right);
    }

    /** Returns the base point for the right group */
    public static function chooseBaseRight<T: DhxPoint>(
        left: T, right: EdgeGroup<T>
    ): T {
        return chooseBase(right, CounterClockwise, right.bottomLeft(), left);
    }

    /** Merges together sets of edges */
    public static function merge<T: DhxPoint>(
        left: EdgeGroup<T>, right: EdgeGroup<T>
    ): EdgeGroup<T> {
        var baseRight = chooseBaseRight(left.bottomRight(), right);
        var baseLeft = chooseBaseLeft(left, baseRight);

        mergeWithBase(left, right, baseLeft, baseRight);
        left.addAll( right );

        return left;
    }
}


