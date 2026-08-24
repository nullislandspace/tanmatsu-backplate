// Tanmatsu backplate + custom modifications
//
// Baked geometry exported from Tanmatsu_3D-printed-with-camera-mount.FCStd.
// Not parametric, but valid as an operand in any OpenSCAD boolean.
//
// Regenerate after changing the FreeCAD model:
//   freecadcmd scripts/export_backplate.py
//
// PART EXTENTS (mm) -- note the part is NOT at Z=0:
//   backplate     X[-60.0, 60.0]  Y[-67.5, 67.5]  Z[-13.6,  3.9]
//   camera_mount  centred on the lens hole, 28.0 x 26.6 x 5.0
//
// The render() below is required, not decoration: OpenCSG (F5 preview)
// cannot depth-peel a subtraction against geometry this concave, and shows
// see-through faces at any convexity value. render() forces exact geometry
// in preview too, so F5 matches F6. First F5 after an edit is slower.

include <scad/backplate.scad>
include <scad/camera_mount.scad>

show_camera_mount = true;

$fn = 64;

render(convexity = 10)
difference() {
    union() {
        backplate();
        if (show_camera_mount) camera_mount();

        // --- ADD material here ---
        // translate([0, 0, 3.9]) cylinder(h = 3, r = 4);
    }

    // --- SUBTRACT material here ---
    // Overshoot past both surfaces so no zero-thickness faces remain.
    translate([-40, -28, -23]) {
        cube([80, 30, 10]);
    }
}
