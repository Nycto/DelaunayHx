package;

import delaunay.RealPoint;
import massive.munit.Assert;

class RealPointTest {

    @Test public function testEquality():Void {
        Assert.isTrue( new RealPoint(1, 2).equals( new RealPoint(1, 2) ) );
        Assert.isFalse( new RealPoint(50, 2).equals( new RealPoint(1, 2) ) );
    }

}
