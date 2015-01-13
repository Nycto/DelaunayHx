DelaunayHx [![Build Status](https://travis-ci.org/Nycto/DelaunayHx.svg?branch=master)](https://travis-ci.org/Nycto/DelaunayHx)
==========

A Haxe library to calculate the Delaunay Triangulation for a set of points. This
is accomplished using a divide and conquer algorithm, as described here:

http://www.geom.uiuc.edu/~samuelp/del_project.html

[![Delaunay Example](http://nycto.github.io/DelaunayHx/DelaunaySample.png)](http://nycto.github.io/DelaunayHx/)

Demo
----

A demo of the output can be found here:

http://nycto.github.io/DelaunayHx/

The full source for that sample can be found here:

https://github.com/Nycto/DelaunayHx/tree/master/sample

Usage
-----

Start by implementing the `DhxPoint` interface, which allows you to use a set of
your own objects as points when running the triangution:

```haxe
package;

import delaunay.DhxPoint;

class Coordinate implements DhxPoint {
    private var lat: Float;
    private var long: Float;
    public function new ( lat: Float, long: Float ) {
        this.lat = lat;
        this.long = long;
    }
    public inline function getX(): Float { return lat; }
    public inline function getY(): Float { return long; }
}
```

If you don't want to define your own point object, you can use the ready made
`RealPoint`, which just implements the `DhxPoint` interface, like this:

```haxe
new RealPoint(2, 2);
```

Next, accumulate your list of points into a `Triangulate` object:

```haxe
// Define a set of points
var triangulate = new delaunay.Triangulate([
    new Coordinate(0, 0), new Coordinate(0, 4)
]);

// Add additional points if needed
triangulate.add( new Coordinate(2, 2) );
```

Finally, execute the calculation and iterate over the results by calling the
`eachEdge` function:

```haxe
triangulate.eachEdge(function (point1, point2) {
    // Do something with the edge formed by connecting point1 and point2
});
```

If you would rather have an array of `Edge` objects, you can also call
`getEdges`:

```haxe
var edgeArray = triangulate.getEdges();
```

Note: The Triangulate object doesn't cache results. Every time you call
`eachEdge` or `getEdges`, the work will be re-done.

Complete Example
----------------

```haxe
package;

import delaunay.Triangulate;
import delaunay.RealPoint;

class Example {
    static public function main(): Void {
        var triangulate = new delaunay.Triangulate([
            new Coordinate(0, 0), new Coordinate(0, 4),
            new Coordinate(2, 2), new Coordinate(6, 2)
        ]);

        triangulate.eachEdge(function (point1, point2) {
            trace(point1 + " -> " + point2);
        });
    }
}
```

License
-------

This library is released under the MIT License, which is pretty spiffy. You
should have received a copy of the MIT License along with this program. If
not, see http://www.opensource.org/licenses/mit-license.php


