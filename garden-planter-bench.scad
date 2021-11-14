use <dotSCAD/src/path_extrude.scad>;
use <dotSCAD/src/bezier_curve.scad>;
use <Round-Anything/polyround.scad>;


// Next steps:
// * figure out the desired ultimate shape
// * figure out whether to use scaling extrusion or retating extrusion + difference with (scaled) spheres
// * find appropriate tool to achieve the job
//   * consider: https://openhome.cc/eGossip/OpenSCAD/lib3x-path_scaling_sections.html

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