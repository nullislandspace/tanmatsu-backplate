rotate([180, 0, 0]) {
    difference() {
        translate([-4, -8, 0]) {
            cube([110, 40, 10.6]);
        }

        union() {
            translate([-2, 0, -0.05]) {
                cube([104.5, 21.5, 10.7]);
            }
            translate([3, -4, -0.05]) {
                cube([94, 4, 5.7]);
            }
        }
    }
}

// topleft
translate([1.5, 5.5, 0]) {
    cylinder(d=1.5, h=3.2, $fn=60);
}

// bottomleft
translate([1.5, 5.5-29.5, 0]) {
    cylinder(d=1.5, h=3.2, $fn=60);
}

// topright
translate([1.5+96, 5.5, 0]) {
    cylinder(d=1.5, h=3.2, $fn=60);
}

// bottomright
translate([1.5+96, 5.5-29.5, 0]) {
    cylinder(d=1.5, h=3.2, $fn=60);
}