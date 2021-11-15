use <dotSCAD/src/path_extrude.scad>;
use <dotSCAD/src/bezier_curve.scad>;
use <Round-Anything/polyround.scad>;
use <dotSCAD/src/surface/sf_thicken.scad>;
use <dotSCAD/src/bezier_surface.scad>;

// Next steps:
// * figure out the desired ultimate shape
// * figure out whether to use scaling extrusion or rotating extrusion + difference with (scaled) spheres
//    A: general approach: (a) make single straight seat (not semicircular), (b) replicate, (c) use openhome.cc `bend` utility to give it the semicircular shape, (d) slice. For (a), do it by (a1) base box, (a2) openhome.cc bezier surface based scoop-out for the seat, (a3) Minkowski sum to smooth out the edges
// * find appropriate tool to achieve the job
//    Investigating details of how to achieve a2, the most risky part
//    Answer: bezier 




ctrl_pts = [
    [[0, 0, 20],  [60, 0, 15],   [90, 0, 15],    [200, 0, 45]],
    [[0, 50, 30], [100, 60, -25], [120, 50, -25], [200, 50, 5]],
    [[0, 100, 0], [60, 120, -35],  [90, 100, -35],  [200, 100, 45]],
    [[0, 150, 0], [60, 150, 15], [90, 180, 15],  [200, 150, 45]]
];

thickness = 20;
t_step = 0.05;

g_pts = bezier_surface(t_step, ctrl_pts);



minkowski() {

difference() {
translate([0,0,-40])        
cube([200,200,40]);
    sf_thicken(g_pts, thickness);

}

sphere(r=5);
}