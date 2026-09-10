// Tanmatsu backplate + custom modifications
// For Black&White camery module
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

camera_x = 13;
camera_y = 15;
camera_z = -13;

$fn = 64;

module camera_pin(xoffs = 0, yoffs = 0, zoffs = 0) {
    translate([xoffs, yoffs, zoffs]) {
        cylinder(d=1.8, h=6, $fn=60);
    }
}

module camera_adds(xoffs = 0, yoffs = 0, zoffs = 0) {
    translate([xoffs, yoffs, zoffs]) {
        camera_pin(1.7, 1.7, 0);
        camera_pin(1.7+1.8+25.8, 1.7, 0);
        camera_pin(1.7, 1.7+1.8+25.8, 0);
        camera_pin(1.7+1.8+25.8, 1.7+1.8+25.8, 0);
    }
}

module camera_removes(xoffs = 0, yoffs = 0, zoffs = 0) {
    translate([xoffs, yoffs, zoffs]) {
        /*
        translate([15.5, 15.5, -10]) {
            cylinder(d=16, h=20, $fn=180);
        }
        */
        translate([6, 6, -10]) {
            cube([19, 19, 20]);
        }
        translate([1, 12.5, -10]) {
            cube([29, 6, 20]);
        }
    }
}

module irport(xoffs = 0, yoffs = 0, zoffs = 0) {
    translate([xoffs, yoffs, zoffs]) {
        cube([9, 20, 6.1]);
    }

}

//render(convexity = 10)
module mainbackplate() {
    difference() {
        union() {
            backplate();

            // --- ADD material here ---
            // translate([0, 0, 3.9]) cylinder(h = 3, r = 4);
            camera_adds(camera_x, camera_y, camera_z);
            
        }

        // --- SUBTRACT material here ---
        union() {
            camera_removes(camera_x, camera_y, camera_z);
        }
    }
}

module extension_screwable() {
    difference() {
        union() {
            backplate();

        }

        // --- SUBTRACT material here ---
        union() {
            translate([-47, -60, -15]) {
                cube([94, 119, 30]);
            }
            translate([-55, -4, -15]) {
                cube([110, 62, 30]);
            }
            irport((-33.8+11.2), 50, -7.6);
        }
    }
}

module extension_middle() {
    difference() {
        union() {
            backplate();
            
            // SIDEPLATE 1
            translate([55.1, -2, -7]) {
                cube([3, 54, 5.5]);
            }
    
            // Sideplate 2
            translate([-58, -2, -10]) {
                cube([3, 60, 8.5]);
            } 
        }

        // --- SUBTRACT material here ---
        union() {
            // bACK
            translate([-44, -58, -15]) {
                cube([88, 117, 30]);
            }
            
            translate([-55, -2, -15]) {
                cube([110, 60, 30]);
            }
            
            // Sideplate 1
            translate([57.5, -2, -11]) {
                cube([3, 54, 8]);
            }
            // Sideplate 2
            translate([-61, -2, -14]) {
                cube([3, 60, 12.5]);
            } 

            // screwholes
            translate([-0, -61, -16]) {
                cylinder(d=4.2, h=20);
            }
            translate([-47, -55.5, -16]) {
                cylinder(d=4.2, h=20);
            } 
            translate([47, -55.5, -16]) {
                cylinder(d=4.2, h=20);
            } 
            translate([49, -6, -16]) {
                cylinder(d=4.2, h=20);
            } 
            translate([-49, -6, -16]) {
                cylinder(d=4.2, h=20);
            } 
            translate([-30, 61.3, -16]) {
                cylinder(d=4.2, h=20);
            } 
            translate([32.5, 61.3, -16]) {
                cylinder(d=4.2, h=20);
            } 
        }
    }
}

/*
color("blue") {
            translate([32.5, 61.3, -16]) {
                cylinder(d=4.2, h=20);
            } 
}
*/
extension_middle();