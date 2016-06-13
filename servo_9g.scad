$fn = 128;

// these are all guesses
W = 12.5;   // .49" at widest, .47" at narrowest (which .22" above bottom)
L = 22.5;   // .88" - .89"
H = 22.5;   // .88"
servo_flange_extent = 5;  // (1.27" - .88")/2 = .195"
servo_main_box_dim = [W, L, H];
servo_flange_dim = [W, L+2*servo_flange_extent, 2.5];  // height = .1"
servo_flange_height = 15.7; // .62"
servo_big_cyl_rad = W/2;
servo_big_cyl_height = 4.3; // .17"
servo_big_cyl_pos = [W/2, 16, H];    // ?
servo_small_cyl_rad = 5.5/2; // diam = .22"
servo_small_cyl_height = 4.3;
servo_small_cyl_pos = [W/2, 10, H];  // ?
servo_wire_dim = [3.5, 5, 1.27];  // [.14, ..., .05]
servo_wire_pos = [W/2 - servo_wire_dim[0]/2, L, 5];  // .2" above bottom

servo_screw_hole_rad = 1; // diam = .08"
servo_screw_hole_dist = 1 + 1.7; // .07" from inside
servo_screw_hole_pos_1 = [W/2, -servo_screw_hole_dist, servo_flange_height-1];
servo_screw_hole_pos_2 = [W/2, L+servo_screw_hole_dist, servo_flange_height-1];


module servo_9g() {
    difference() {
        union() {
            cube(servo_main_box_dim);
            T([0, -servo_flange_extent, servo_flange_height]) 
              cube(servo_flange_dim);
            T(servo_big_cyl_pos) 
              cylinder(r=servo_big_cyl_rad, h=servo_big_cyl_height);
            T(servo_small_cyl_pos) 
              cylinder(r=servo_small_cyl_rad, h=servo_small_cyl_height);
            T(servo_wire_pos)
              cube(servo_wire_dim);
        }
        T(servo_screw_hole_pos_1)
          cylinder(r=servo_screw_hole_rad, h=servo_flange_dim[2]+2);
        T(servo_screw_hole_pos_2)
          cylinder(r=servo_screw_hole_rad, h=servo_flange_dim[2]+2);
    }
}

servo_9g();

include <shortcuts.scad>