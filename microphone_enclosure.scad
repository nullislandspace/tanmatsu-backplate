$fn=60;
module hollow() {

    translate([-4, -4, -2]) {
        cube([70, 38, 2]);
    }

    translate([0, 0, -1]) {
        cube([62, 31, 3]);
    }
    translate([0, 2, 0]) {
        cube([62, 27, 9]);
    }
    for(xoffs = [3 : 4 : 23]) {
        translate([xoffs, 2, 0]) {
            minkowski() {
                cube([1, 27, 12]);
                sphere(1);
            }
        }
    }
    for(xoffs = [57 : -4 : 37]) {
        translate([xoffs, 2, 0]) {
            minkowski() {
                cube([0.8, 27, 12]);
                sphere(1);
            }
        }
    }
}


module block_round() {
    translate([0, 0, 0]) {
        minkowski() {
            cube([62, 30, 11]);
            sphere(1.5);
        }
    }
}

difference() {
    block_round();
    hollow();
}

    translate([24.5, 7.5, 12.5]) {
        color("blue") {
            linear_extrude(0.4) {
                text(text="𝅘𝅥𝅮", font="Noto Music:style=Bold", size=13);
            }
        }
    }

