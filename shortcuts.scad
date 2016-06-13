//include </u/a/3dprint/alanlib/shortcuts.scad>;
//include <shortcuts.scad>  <- only works if run from terminal
module R(v) {rotate(v) children();}
module T(v) {translate(v) children();}
module S(v) {scale(v) children();}
module Rx(a=90) {rotate([a, 0, 0]) children();}
module Ry(a=90) {rotate([0, a, 0]) children();}
module Rz(a=90) {rotate([0, 0, a]) children();}
module Tx(d) {translate([d, 0, 0]) children();}
module Ty(d) {translate([0, d, 0]) children();}
module Tz(d) {translate([0, 0, d]) children();}
module Sx(s) {scale([s, 1, 1]) children();}
module Sy(s) {scale([1, s, 1]) children();}
module Sz(s) {scale([1, 1, s]) children();}

// TODO: rename this to utils.scad
// TODO: create shapes.scad, move stuff there

mm_per_in = 25.4;
eps = .001;
phi = (sqrt(5)+1)/2; // useful for regular solids
O = 0; // silly sugar for hiding syntax highlighting

module brim_scale(s = [0.9, 1.1], height=.3) {
    // to be used for objects with multiply-connected footprints - 
    // the minkowski method doesn't work well for that case
    //
    // designed to work for objects that :
    // - rest on the x-y plane
    // - are somewhat centered on the origin
    union() {
        children();
        linear_extrude(height=height)
        difference() {
            scale([s[1], s[1], s[0]]) hull() projection(cut=true) children();
            scale([s[0], s[0], s[1]]) hull() projection(cut=true) children();
        }
    }
}

module dremel_footprint() {
    difference() {
        cube([232, 152, 1], center=true);
        cube([230, 150, 2], center=true);
    }
}

module brim_minkowski(radius=10, height=.3) {
    // i think this produces the "right" result for objects with simply-connected footprints.
    // nonconvex objects with narrow crevices might not do well.
    //
    // designed to work for objects that:
    // - rest on the x-y plane (?)
    // - have simply-connected footprints
    union() {
        minkowski() {
            linear_extrude(height=eps)
                projection(cut=true)
                    children();
            cylinder(r=radius, h=height-eps);
        }
        children();
    }
}

module trapezoid_arbitrary_3d(base_width, top_width, height, offs, thickness) {
    // assumes base_width > top_width
    linear_extrude(height=thickness) {
        polygon([[0, 0], 
                 [offs, height], 
                 [offs+top_width, height], 
                 [base_width, 0]]);
    }
}

module trapezoid_3d(base_width, top_width, height, thickness) {
    trapezoid_arbitrary_3d(base_width, top_width, height, (base_width-top_width)/2, thickness);
}

module pill3(r=1, l=1) {
    union() {
        cylinder(r=r, h=l, $fn=64);
        sphere(r=r, $fn=64);
        translate([0, 0, l]) sphere(r=r, $fn=64);
    }
}

module pill2(r=1, l=2, h=.5) {
    linear_extrude(height=h) {
        translate([-r, 0, 0]) square([r*2, l]);
        circle(r, $fn=64);
        translate([0, l, 0]) circle(r, $fn=64);
    }
}

module pill2D(r=1, l=2) {
    translate([-r, 0, 0]) square([r*2, l]);
    circle(r, $fn=64);
    translate([0, l, 0]) circle(r, $fn=64);
}

module rounded_square(dim=[3, 3], r=1, h=1, $fn=64) {
    linear_extrude(height=h) {
        union() {
            translate([-r, 0]) square(dim + [2*r, 0]); 
            translate([0, -r]) square(dim + [0, 2*r]);
            translate([0, 0]) circle(r, $fn);
            translate([0, dim[1]]) circle(r, $fn);
            translate([dim[0], 0]) circle(r, $fn);
            translate([dim[0], dim[1]]) circle(r, $fn);
        }
    }
}

module rounded_cube(dim=[3, 3, 3], r=1, $fn=64) {
    union() {
        // cubes
        translate([-r, 0, 0]) cube(dim + [2*r, 0, 0]);
        translate([0, -r, 0]) cube(dim + [0, 2*r, 0]);
        translate([0, 0, -r]) cube(dim + [0, 0, 2*r]);
        // spheres
        translate([0, 0, 0]) sphere(r, $fn);
        translate([dim[0], 0, 0]) sphere(r, $fn);
        translate([0, dim[1], 0]) sphere(r, $fn);
        translate([dim[0], dim[1], 0]) sphere(r, $fn);
        translate([0, 0, dim[2]]) sphere(r, $fn);
        translate([dim[0], 0, dim[2]]) sphere(r, $fn);
        translate([0, dim[1], dim[2]]) sphere(r, $fn);
        translate([dim[0], dim[1], dim[2]]) sphere(r, $fn);
        // cylinders
        translate([0, 0, 0]) cylinder(r=r, h=dim[0], $fn);
    }
}



module test_object() {
    union() {
        cube([30, 10, 10]);
        cube([10, 30, 10]);
    }
}    

//test_object();
//brim_minkowski() test_object();
//brim_scale() test_object();
//brim_scale() {test_object();}


// material/process constants
// thickness = 2 -> notch width = 2.4
ACRYLIC_60mil = 1.5;
LASER_KERF_ACRYLIC_60mil = .3; 
// this is an adjustment to the material width which accounts for
// the small amount of material lost in the cut.
// not sure yet whether this depends on the material/thickness.
// i suspect that it might depend on the laser power/speed,
// which is determined by the material/thickness


module laser_fiducial() {
    polygon([[0, 0], [0, 1], [1, 0]]);    
}



































// workaround for buggy line counts in error messages
echo("200 lines in shortcuts.scad");