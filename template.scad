include <shortcuts.scad>

epsilon = .005;
$fn = 128;
t = ACRYLIC_60mil;
t_notch = t - LASER_KERF_ACRYLIC_60mil; 

module reference() {
    // define reference objects, not to be included in cut
}

module object_2d() {
    // define object to be cut out with laser
    // use 2D primitives here
}

module shape_2d() {
    // define object to be etched with laser
    // use 2D primitives here
}

module object_3d() {
    // convert 2D shapes to 3D for visual design aid
    linear_extrude(height=t) {
        object_2d();
    }
}

module assembled() {
    // assemble parts of project in real 3D configuration
    object_3d();
}

module flat_cut() {
    // assemble parts of project in 2D layout suitable for laser bed
    laser_fiducial();
    object_2d();
}

module flat_etch() {
    // assemble etch layer parts
    shape_2d();
}



// the following block should not need to be modified, 
// except to add additional etch layers
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
