use <servo_9g.scad>
use <servo_horn_mount_laser.scad>
include <shortcuts.scad>

epsilon = .005;
$fn = 128;
t = ACRYLIC_60mil;
t_notch = t - LASER_KERF_ACRYLIC_60mil; 

module servo_pair() {
    T([2.5, 25, 22.5]) Rx(180) servo_9g();
    T([-10, 25, 0]) Rx(90) servo_9g();    
}

module reference() {
    servo_pair();
}

module h_bracket_2d() {
    difference() {
        square([26-epsilon, 32.5]);
        // screw holes
        T([22.75, 2.25]) circle(r=1);
        T([22.75, 30.25]) circle(r=1);
        // body hole
        T([6-t, 5]) square([10*2+t, 22.5]);
        // notch
        #T([-1, 11.75]) square([2.5+1, t_notch]);
    }
}

module v_bracket_2d() {
    // TODO: consider conforming to angular profile of servo
    difference() {
        Tx(13+epsilon) square([18, 32.5]);
        // screw holes
        T([19.75, 2.25]) circle(r=1);
        T([19.75, 30.25]) circle(r=1);
        // body hole
        T([6-t, 5]) square([10*2+t, 22.5]);
        // notch
        #T([25, 10]) square([2.5+1, t_notch]);
    }    
}

module h_bracket_3d() {
    linear_extrude(height=t) {
        h_bracket_2d();
    }
}

module v_bracket_3d() {
    linear_extrude(height=t) {
        v_bracket_2d();
    }
}

module assembled() {
    T([-14, -2.5, 2.3]) h_bracket_3d();
    T([16, 9.25, -5]) Rz(180) Rx(90) v_bracket_3d();
    // TODO: combine etch and cut here
    T([-5, -8, 20]) Ry(-45  ) Ry(180) Ry(90) Rx(-90) horn_arm_cut();
}

module flat_cut() {
    laser_fiducial();
    T([0, -40]) h_bracket_2d();
    T([3, -46]) v_bracket_2d();
    T([16, -24.5]) horn_arm_cut();
}

module flat_etch() {
    laser_fiducial();
    T([16, -24.5]) horn_arm_etch();
}



module horn_arm_cut() {
    camera_screw_diam = 1;
    camera_screw_len = 5;
    camera_screw_dist = 13; 
    // derive below from above
    L = 7;
    difference() {
        union() {
            T([0, -5]) circle(r=10);
            T([-10, -12]) square([20, 7]);
        }
        // axial screw hole
        circle(r=1);
        
        // cut off remainder of big circle
        T([-11, -20]) square([22, 11]);
        // camera screw holes
        #T([-camera_screw_diam/2+camera_screw_dist/2, -L-3]) 
          square([camera_screw_diam, camera_screw_len]);
        #T([-camera_screw_diam/2-camera_screw_dist/2, -L-3]) 
          square([camera_screw_diam, camera_screw_len]);
    }
}

module horn_arm_etch() {
    star_joint_9g();
}

MODE="design";  // {"design", "cut", "etch"}
if(MODE=="design") {
    #reference();
    assembled();
    linear_extrude(height=t) flat_cut();
    #Tz(t/2+epsilon) linear_extrude(height=t/2) flat_etch();
} else if(MODE=="cut") {
    flat_cut();
} else if(MODE=="etch") {
    flat_etch();
}
