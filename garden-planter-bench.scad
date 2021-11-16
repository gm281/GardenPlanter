use <dotSCAD/src/path_extrude.scad>;
use <dotSCAD/src/bezier_curve.scad>;
use <Round-Anything/polyround.scad>;
use <dotSCAD/src/surface/sf_thicken.scad>;

// Next steps:
// * figure out the desired ultimate shape
// * figure out whether to use scaling extrusion or rotating extrusion + difference with (scaled) spheres
//    A: general approach: (a) make single straight seat (not semicircular), (b) replicate, (c) use openhome.cc `bend` utility to give it the semicircular shape, (d) slice. For (a), do it by (a1) base box, (a2) openhome.cc bezier surface based scoop-out for the seat, (a3) Minkowski sum to smooth out the edges
// * find appropriate tool to achieve the job
//    Investigating details of how to achieve a2, the most risky part
// * base: (a) decide number of seats, (b) calculate major parameters, (c) make it

/* From `garden-planter.scad`:
ECHO: "Number of elements: ", 65
ECHO: "Half cut angle: ", 69.4313
ECHO: "Number of elements: ", 26
ECHO: "Bench walls center offset: ", 1120
ECHO: "Outer bench wall radius: ", 2120
ECHO: "Inner bench wall radius: ", 1670
ECHO: "Half cut angle: ", 90.5682
ECHO: "Number of elements: ", 27

Meansurments of the white garden chair:
Max depth: 45
Back to front: 80 to max depth, 280 from max depth to min depth, 40 to front
Seat width: 450
Armrest width: 550

Calculations:
* 69.4313 * 2 degree slice will be used by the seats
* radius of the front edge of the seat will be around 1670 - 30 - 30 (to accomodate overhangs) = 1610
* circumverence that can be used for seats: 3898
* at 550mm it gives 7 seats, if using 6 seats, it'll give 650
* using that, since the front of the legs will be closer still
* the 20-odd degree angle also alows to fit almost the complete next seat along the front of the bench (back won't fit). Since the front results in a slightly (<1degree) narrower angle, using that for the calculations

* angle for each seat is: 90.57*2/8 = 22.6 degrees
*/
bench_back_angle=69.4313 * 2;
inner_bench_wall_radius=1670;







/*
ctrl_pts = [
    [[0, 0, 20],  [60, 0, -35],   [90, 0, 60],    [200, 0, 5]],
    [[0, 50, 30], [100, 60, -25], [120, 50, 120], [200, 50, 5]],
    [[0, 100, 0], [60, 120, 35],  [90, 100, 60],  [200, 100, 45]],
    [[0, 150, 0], [60, 150, -35], [90, 180, 60],  [200, 150, 45]]
];

thickness = 2;
t_step = 0.05;

bezier_pts = [for(i = [0:len(ctrl_pts) - 1]) 
    bezier_curve(t_step, ctrl_pts[i])
]; 

g_pts = [for(j = [0:len(bezier_pts[0]) - 1]) 
    bezier_curve(t_step, 
        [for(i = [0:len(bezier_pts) - 1]) bezier_pts[i][j]]
    ) 
];

sf_thicken(g_pts, thickness);
*/


/*
// This is what I've sent to Tomek:
outer_bench_wall_radius=2120;
bench_width=450;
bench_extra_width=30;
bench_height=30;
bench_base_overhang=20;



bench_cross_section_points=[
[0,-bench_base_overhang/2,0],
[bench_width, -bench_base_overhang/2,0],
[bench_width, -bench_base_overhang,0],
[bench_width+bench_extra_width, -bench_base_overhang,10],
[bench_width+bench_extra_width, bench_height,20],
[0, bench_height,0],
];

shape_pts=polyRound(bench_cross_section_points,100);

projection(cut = true)
rotate([0,10,0])
rotate([90,0,0])

difference() {
rotate_extrude(angle=90, convexity=10, $fn=500)
translate([outer_bench_wall_radius, 0]) 
polygon(points=shape_pts);
    
rotate_extrude(angle=90, convexity=10, $fn=500)
translate([outer_bench_wall_radius, 0]) 
translate([bench_width/2, bench_height*2])
scale([1*bench_width,2*(bench_height+bench_base_overhang)])
circle(r=0.5,$fn=200);
}
*/


/*
projection(cut = true)
rotate([0,10,0])
rotate([90,0,0])
*/
/*
rotate_extrude(angle=90, convexity=10, $fn=500)
translate([outer_bench_wall_radius, 0]) 
polygon(points=shape_pts);
*/






/*
t_step_1 = 0.05;
t_step_2 = 0.005;
width = 2;

p0 = [0, 0, 0];
p1 = [40, 60, 35];
p2 = [-50, 70, 0];
p3 = [20, 150, -35];
p4 = [30, 50, -3];

shape_pts = 
bezier_curve(t_step_1,
[   
    [5, -5],
    [3, 4],
    [0, 5],
    [-5, -5] 
]
);

path_pts = bezier_curve(t_step_2, 
    [p0, p1, p2, p3, p4]
);



projection(cut = true)
rotate([0,40,0])
path_extrude(shape_pts, path_pts);
*/


/*



outer_bench_wall_radius=2120;
bench_width=450;
bench_extra_width=30;
bench_height=30;
bench_base_overhang=20;



bench_cross_section_points=[
[0,-bench_base_overhang],
[bench_width+bench_extra_width, -bench_base_overhang],
[bench_width+bench_extra_width, bench_height],
[0, bench_height],
];



rotate_extrude(angle=270, convexity=10, $fn=200)
translate([outer_bench_wall_radius, 0]) 
 polygon(points=bench_cross_section_points);
 
 */