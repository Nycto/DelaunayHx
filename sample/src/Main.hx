package;

import delaunay.RealPoint;
import delaunay.Triangulate;

class Main {

    static function main() {
        for (
            canvasNode in
            js.Browser.document.querySelectorAll("canvas.delaunay")
        ) {
            var canvas = cast( canvasNode, js.html.CanvasElement );

            var nodes = new Triangulate([]);
            for ( i in 0...100 ) {
                nodes.add( new RealPoint(
                    Std.random(canvas.clientWidth),
                    Std.random(canvas.clientHeight)
                ) );
            }

            var edges = "";

            var context = canvas.getContext2d();
            context.beginPath();
            nodes.eachEdge(function( a, b ) {
                edges += a + " -> " + b + "\n";
                context.moveTo( a.getX(), canvas.clientHeight - a.getY() );
                context.lineTo( b.getX(), canvas.clientHeight - b.getY() );
            });
            context.stroke();

            trace(edges);
        }
    }
}

