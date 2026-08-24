module body() {
    cube([32, 32, 1.5]);
}

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

difference() {
    union() {
        body();
        camera_adds();
    }
    camera_removes();
}

translate([-5, 0, 0]) {
    cube([5, 5, 1.5]);
}
