include </u/a/3dprint/alanlib/shortcuts.scad>;

// see generate_star_points.py 
//N = 21
//r1 = 5.0 / 2
//r2 = 4.5 / 2
star_points_9g = [[2.5, 0.0],
 [2.224869359006539, 0.3353450988963924],
 [2.388932014465352, 0.7368879360272604],
 [2.0271799527804433, 0.9762384130145058],
 [2.065596935789987, 1.4083001451590549],
 [1.6493667116171093, 1.5303886599845686],
 [1.5587245046468339, 1.9545787061700741],
 [1.1250000000000002, 1.9485571585149868],
 [0.913352560915988, 2.3271843716105103],
 [0.5006721014017075, 2.193587802409103],
 [0.18682523396606093, 2.4930094929529503],
 [-0.1681427105694546, 2.243708543657655],
 [-0.5563023348907858, 2.437319780454559],
 [-0.822017304824389, 2.0944659344494596],
 [-1.2499999999999996, 2.1650635094610973],
 [-1.40285205418215, 1.7591208355530674],
 [-1.832629679574565, 1.7004318444272992],
 [-1.859037242210988, 1.26747013064315],
 [-2.2524221697560476, 1.0847093477938956],
 [-2.1500388130188166, 0.6631991424245344],
 [-2.4720770655628215, 0.3726056654404367],
 [-2.25, 2.755455298081545e-16],
 [-2.4720770655628215, -0.37260566544043616],
 [-2.1500388130188166, -0.6631991424245348],
 [-2.252422169756048, -1.084709347793895],
 [-1.8590372422109884, -1.2674701306431497],
 [-1.8326296795745656, -1.7004318444272988],
 [-1.4028520541821508, -1.7591208355530668],
 [-1.250000000000001, -2.165063509461096],
 [-0.8220173048243885, -2.0944659344494596],
 [-0.5563023348907865, -2.4373197804545588],
 [-0.16814271056945362, -2.243708543657655],
 [0.18682523396605868, -2.4930094929529507],
 [0.5006721014017069, -2.193587802409103],
 [0.9133525609159865, -2.327184371610511],
 [1.125, -1.9485571585149868],
 [1.5587245046468334, -1.9545787061700748],
 [1.6493667116171085, -1.5303886599845695],
 [2.065596935789987, -1.4083001451590549],
 [2.027179952780443, -0.9762384130145061],
 [2.388932014465351, -0.7368879360272618],
 [2.224869359006539, -0.33534509889639436]];


module star_joint_9g() {
    // .95 too small
    // .96 is pretty good
    // .97 works but wiggles a little
    scale(.96) polygon(points=star_points_9g);
}

module test_mount() {
    d = 5;
    difference() {
        union() {
            circle(r=d, $fn=128); 
            T([-d, 0]) square(2*d);
        }
        star_joint_9g();
    }
}

//star_joint_9g();
test_mount();
