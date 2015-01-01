package;

import delaunay.Set;
import delaunay.Triangulate;
import delaunay.DhxPoint;
import delaunay.RealPoint;
import delaunay.Edge;
import massive.munit.Assert;
import haxe.PosInfos;

class LargeDataTest {

    private function p ( x: Float, y: Float ): RealPoint {
        return new RealPoint(x, y);
    }

    private function e (
        x1: Float, y1: Float,
        x2: Float, y2: Float
    ): Edge<RealPoint> {
        return new Edge( p(x1, y1), p(x2, y2) );
    }

    private function es ( from: RealPoint, to: Array<RealPoint> ) {
        return Lambda.array( Lambda.map(to, function (point) {
            return new Edge(from, point);
        }) );
    }

    private function tri (
        x1: Float, y1: Float,
        x2: Float, y2: Float,
        x3: Float, y3: Float
    ) {
        return [ e(x1, y1, x2, y2), e(x2, y2, x3, y3), e(x3, y3, x1, y1) ];
    }

    @Test public function test15Points() {
        // These points were taken from here:
        // http://www.mathworks.com/help/matlab/math/voronoi-diagrams.html

        var x1 = p(-1.5, 3.2);
        var x2 = p(1.8, 3.3);
        var x3 = p(-3.7, 1.5);
        var x4 = p(-1.5, 1.3);
        var x5 = p(0.8, 1.2);
        var x6 = p(3.3, 1.5);
        var x7 = p(-4.0, -1.0);
        var x8 = p(-2.3, -0.7);
        var x9 = p(0, -0.5);
        var x10 = p(2.0, -1.5);
        var x11 = p(3.7, -0.8);
        var x12 = p(-3.5, -2.9);
        var x13 = p(-0.9, -3.9);
        var x14 = p(2.0, -3.5);
        var x15 = p(3.5, -2.25);

        Helper.assertEdges(Helper.flatten([
            es(x1, [ x3, x4, x5, x2 ]),
            es(x2, [ x1, x5, x6 ]),
            es(x3, [ x7, x8, x4, x1 ]),
            es(x4, [ x1, x5, x9, x8, x3 ]),
            es(x5, [ x2, x6, x10, x9, x4, x1 ]),
            es(x6, [ x11, x10, x5, x2 ]),
            es(x7, [ x3, x8, x12 ]),
            es(x8, [ x4, x9, x13, x12, x7, x3 ]),
            es(x9, [ x5, x10, x13, x8, x4 ]),
            es(x10, [ x6, x11, x15, x14, x13, x9, x5 ]),
            es(x11, [ x15, x10, x6 ]),
            es(x12, [ x8, x13, x7 ]),
            es(x13, [ x9, x10, x14, x12, x8 ]),
            es(x14, [ x10, x15, x13 ]),
            es(x15, [ x11, x14, x10 ])
        ]));
    }

    @Test public function test10Points() {
        // These points were taken from here:
        // http://www.geom.uiuc.edu/locate/user/samuelp/rnd_10.ps

        Helper.assertEdges(Helper.flatten([
            tri(25.621, 183.763, 189.82, 187.408, 34.7438, 169.193),
            tri(34.7438, 169.193, 149.8, 136.398, 78.5315, 105.348),
            tri(34.7438, 169.193, 189.82, 187.408, 149.8, 136.398),
            tri(78.5315, 105.348, 149.8, 136.398, 242.773, 38.4628),
            tri(149.8, 136.398, 248.387, 63.4285, 242.773, 38.4628),
            tri(242.773, 38.4628, 248.387, 63.4285, 295.668, 67.0482),
            tri(25.621, 183.763, 266.461, 393.537, 189.82, 187.408),
            tri(189.82, 187.408, 266.461, 393.537, 319.379, 171.034),
            tri(248.387, 63.4285, 319.379, 171.034, 295.668, 67.0482),
            tri(189.82, 187.408, 319.379, 171.034, 248.387, 63.4285),
            tri(149.8, 136.398, 189.82, 187.408, 248.387, 63.4285)
        ]));
    }
}

