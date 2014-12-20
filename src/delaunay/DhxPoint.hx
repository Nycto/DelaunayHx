package delaunay;

/**
 * An object that can be used as an input point when creating a Delaunay
 * triangulation.
 *
 * Defining this as an interface means that API consumers can use their own
 * objects when generating the graph if they want to
 */
interface DhxPoint {

    /** Returns the X coordinate */
    function getX(): Float;

    /** Returns the Y coordinate */
    function getY(): Float;
}

