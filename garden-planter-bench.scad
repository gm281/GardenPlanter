use </Users/gmilos/iCloudDrive/Projects/GardenPlanter/dotSCAD/src/path_extrude.scad>;
use </Users/gmilos/iCloudDrive/Projects/GardenPlanter/dotSCAD/src/bezier_curve.scad>;
use </Users/gmilos/iCloudDrive/Projects/GardenPlanter/dotSCAD/src/bend.scad>;
use </Users/gmilos/iCloudDrive/Projects/GardenPlanter/Round-Anything/polyround.scad>;
use </Users/gmilos/iCloudDrive/Projects/GardenPlanter/dotSCAD/src/surface/sf_thicken.scad>;

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

quality_factor=5; /* Increase higher for final redering */
cylinder_frags=5*360;
bench_front_angle=90.5682 * 2;
bench_back_angle=69.4313 * 2;
number_of_seats=8;
seat_angle=bench_front_angle / number_of_seats;
inner_bench_wall_radius=1670;
outer_bench_wall_radius=2120;
base_overhang=30;
seat_overhang=25;
base_back_hight_delta=25;
base_thickness=18;
additional_base_thickness=50;
bench_height=80;
seat_lip_height=25;
base_z_adjustment=6;
lip_smoothing_radius=10;

module base_panel(additional_base_back_factor=2) {

    bench_front_back_diff=outer_bench_wall_radius-inner_bench_wall_radius;
    base_scale_factor=sqrt(base_back_hight_delta*base_back_hight_delta + bench_front_back_diff*bench_front_back_diff)/bench_front_back_diff;
    base_length=base_scale_factor*cos(seat_angle/2)*(additional_base_back_factor*bench_front_back_diff + base_overhang);
    base_front_width=2*(inner_bench_wall_radius-base_overhang)*sin(seat_angle/2);
    base_back_width=2*(inner_bench_wall_radius+additional_base_back_factor*bench_front_back_diff)*sin(seat_angle/2);
    base_front_back_angle=atan(base_back_hight_delta/bench_front_back_diff);

    base_points=[
        [-base_front_width/2,0-tan(base_front_back_angle)*(base_thickness+additional_base_thickness),-additional_base_thickness],
        [base_front_width/2,0-tan(base_front_back_angle)*(base_thickness+additional_base_thickness),-additional_base_thickness],
        [base_back_width/2,base_length-tan(base_front_back_angle)*(base_thickness+additional_base_thickness),-additional_base_thickness],
        [-base_back_width/2,base_length-tan(base_front_back_angle)*(base_thickness+additional_base_thickness),-additional_base_thickness],
        [-base_front_width/2,0,base_thickness],
        [base_front_width/2,0,base_thickness],
        [base_back_width/2,base_length,base_thickness],
        [-base_back_width/2,base_length,base_thickness]
    ];

    base_faces=[
        [0,1,2,3],
        [6,7,3,2],
        [5,6,2,1],
        [0,3,7,4],
        [4,5,1,0],
        [7,6,5,4]
    ];


    rotate([base_front_back_angle, 0, 0]) {
        
        difference() {
            translate([0,0,-base_thickness])
            polyhedron(base_points, base_faces);
            

            union() {
                translate([0,-cos(seat_angle/2)*(inner_bench_wall_radius-base_overhang),0]) {
                    cylinder(h=300,r1=inner_bench_wall_radius-base_overhang, r2=inner_bench_wall_radius-base_overhang,center=true, $fn=cylinder_frags);
                }
            
                smoothing_radius=9.5;
                translate([0,-cos(seat_angle/2)*(inner_bench_wall_radius-base_overhang)+smoothing_radius,-smoothing_radius])
                rotate([0,0,90-seat_angle*1.1/2])            
                rotate_extrude(angle=seat_angle*1.1,$fn = quality_factor*cylinder_frags *seat_angle*1.1/360 )
                translate([inner_bench_wall_radius-base_overhang, 0, 0])
                rotate([0,0,90])
                difference() {
                    square(size = [2*smoothing_radius, 2*smoothing_radius], center = false);
                    circle(r = smoothing_radius);
                }

            }
        }
    
        if (quality_factor > 1) {
            translate([0,-cos(seat_angle/2)*(inner_bench_wall_radius-base_overhang)+lip_smoothing_radius,+lip_smoothing_radius-seat_lip_height-base_z_adjustment])
            rotate([0,0,90-seat_angle*1.1/2])            
            rotate_extrude(angle=seat_angle*1.1,$fn = quality_factor*cylinder_frags *seat_angle*1.1/360)
            translate([inner_bench_wall_radius-base_overhang-2*lip_smoothing_radius+1 /*botch, but not sure how to get rid of the step otherwise */, -2, 0])
            rotate([0,0,-90])
            difference() {
                square(size = [2*lip_smoothing_radius, 2*lip_smoothing_radius], center = false);
                circle(r = lip_smoothing_radius);
            }
        }
    }
}

//base_panel();


module single_base() {
    translate([0,cos(seat_angle/2)*(inner_bench_wall_radius-base_overhang),0]) {
        base_panel();
    }
}
module base() {
    for (i = [0:number_of_seats-1]) {
        rotate([0,0,(-number_of_seats/2+0.5+i)*seat_angle]) {
            single_base();
        }
    }
}

//base();


seat_back_width=2*PI*outer_bench_wall_radius*seat_angle/360;


module seat_flow() {  
    bench_width=outer_bench_wall_radius-inner_bench_wall_radius;
    bench_cross_section_points=[
        [-(bench_width+base_overhang+seat_overhang),-seat_lip_height,0],
        [0, -seat_lip_height,0],
        [0, bench_height,0],
        [-(bench_width+base_overhang+seat_overhang), bench_height,0],
    ];
    bench_cross_section=polyRound(bench_cross_section_points,100);

    bench_flow_points=[
        [0 , 0, -100],
        [0 , 0, 0],
        [0 , 0, 50],
        [0, 0, 100],
        [0, -20, 150],
        [0, -20, 200],
        [0, -20, 300],
        [0, -30, 400],
        [0, -30, 500],
        [0, -30, 600],
        [0, -20, 700],
        [0, -20, 800],
        [0, -20, 850],
        [0, 0, 900],
        [0, 0, 940],
        [0, 0, 1000],
        [0, 0, 1100],
    ];
    bench_flow_path = bezier_curve(0.05, bench_flow_points);
    
    scale([seat_back_width/1000,1,1]) {
        intersection() {
            rotate([0,90,0])
                rotate([0,0,90])
                    path_extrude(bench_cross_section, bench_flow_path, method = "AXIS_ANGLE");
                
            translate([0,-250,-500])
                cube([1000,1000,1000]);
        }
    }
}

module bent_seat_flow() {
    bend_frags=quality_factor*24;
    bend_frag_width = seat_back_width / bend_frags;
    bend_frag_angle = seat_angle / bend_frags;
    bend_half_frag_width = 0.5 * bend_frag_width;
    bend_half_frag_angle = 0.5 * bend_frag_angle;
    bend_r = bend_half_frag_width / sin(bend_half_frag_angle);
    
    bench_width=outer_bench_wall_radius-inner_bench_wall_radius;

    translate([0,0,bench_height])
    rotate([0,0,270])
    rotate([0,180,0])
    translate([-bend_r,0,0])
    rotate([0,0,-seat_angle/2])
    bend(size = [seat_back_width, bench_height+seat_lip_height, bench_width+base_overhang+seat_overhang], angle = seat_angle, frags=bend_frags)
    translate([0,bench_height,0])
    rotate([90,0,0])
    seat_flow();
}

//bent_seat_flow();
//translate([-seat_back_width/2,0,0])
//seat_flow();

echo("Seat width: ", seat_back_width);
ctrl_pts = [
    [[-200, 000, 080], [000, 000, -000], [100, 000, -000], [200, 000, -000], [300, 000, -000], [400, 000, -000], [500, 000, -000], [700, 000, 080]],
    [[-200, 010, 080], [000, 010, -000], [100, 010, -000], [200, 010, -000], [300, 010, -000], [400, 010, -000], [500, 010, -000], [700, 010, 080]],
    [[-200, 050, 080], [000, 050, -000], [100, 050, -045], [200, 050, -045], [300, 050, -045], [400, 050, -045], [500, 050, -000], [700, 050, 080]],
    [[-200, 075, 080], [000, 075, -000], [100, 075, -045], [200, 075, -045], [300, 075, -045], [400, 075, -045], [500, 075, -000], [700, 075, 080]],
    [[-200, 100, 080], [000, 100, -000], [100, 100, -045], [200, 100, -045], [300, 100, -045], [400, 100, -045], [500, 100, -000], [700, 100, 080]],
    [[-200, 200, 080], [000, 200, -000], [100, 200, -045], [200, 200, -035], [300, 200, -035], [400, 200, -045], [500, 200, -000], [700, 200, 080]],
    [[-200, 300, 080], [000, 300, -000], [100, 300, -035], [200, 300, -035], [300, 300, -035], [400, 300, -035], [500, 300, -000], [700, 300, 080]],
    [[-200, 400, 080], [000, 400, -000], [100, 400, -015], [200, 400, -005], [300, 400, -005], [400, 400, -015], [500, 400, -000], [700, 400, 080]],
    [[-200, 500, 080], [000, 500, -000], [100, 500, -025], [200, 500, -015], [300, 500, -015], [400, 500, -025], [500, 500, -000], [700, 500, 080]],
    [[-200, 520, 080], [000, 520, -000], [100, 520, -025], [200, 520, -015], [300, 520, -015], [400, 520, -025], [500, 520, -000], [700, 520, 080]],
//    [[-200, 530, 080], [000, 530, -000], [100, 530, -025], [200, 530, -015], [300, 530, -015], [400, 530, -025], [500, 530, -000], [700, 530, 080]],
    [[-200, 650, 040], [000, 550, -050], [100, 550, -145], [200, 550, -235], [300, 550, -235], [400, 550, -145], [500, 550, -050], [700, 650, 040]],
];

thickness = 60;
t_step = 0.05/quality_factor;

bezier_pts = [for(i = [0:len(ctrl_pts) - 1]) 
    bezier_curve(t_step, ctrl_pts[i])
]; 

g_pts = [for(j = [0:len(bezier_pts[0]) - 1]) 
    bezier_curve(t_step, 
        [for(i = [0:len(bezier_pts) - 1]) bezier_pts[i][j]]
    ) 
];


module single_seat() {
    difference() {
        bent_seat_flow();
            
        translate([250,0,thickness/2+bench_height-14])
        rotate([0,0,180])
        sf_thicken(g_pts, thickness);
    }
}

module single_seat_minkowski_smoothed() {
    minkowski() {
        single_seat();
        sphere(r=5);
    }
}


module single_seat_no_base() {
    translate([0,-outer_bench_wall_radius,0])   
    difference() {
        translate([0,outer_bench_wall_radius,0])   
            single_seat();

        union() {
            scale([1.005,1,1])    
            translate([0,0,base_z_adjustment])
                single_base();

            translate([0,0,lip_smoothing_radius-seat_lip_height])
            rotate([0,0,90-seat_angle*1.1/2])            
            rotate_extrude(angle=seat_angle*1.1,$fn = quality_factor*cylinder_frags *seat_angle*1.1/360)
            translate([inner_bench_wall_radius-base_overhang-seat_overhang+lip_smoothing_radius, 0, 0])
            rotate([0,0,180])
            difference() {
                square(size = [2*lip_smoothing_radius, 2*lip_smoothing_radius], center = false);
                circle(r = lip_smoothing_radius);
            }
        }
    }
}

//single_seat_no_base();


number_slices=SLICE_COUNT;
slice_number=SLICE_IDX;

slice_angle=seat_angle/number_slices;

echo("Seat angle: ", seat_angle);
projection(cut = true)
rotate([slice_angle*(number_slices/2-0.5-slice_number),0,0])
translate([0,outer_bench_wall_radius,0])
rotate([0,90,0])
single_seat_no_base();


/*
minkowski() {
    single_seat_no_base();
    sphere(r=2.5);
}
*/

/*
for (i = [0:number_of_seats-1]) {
    rotate([0,0,(-number_of_seats/2+0.5+i)*seat_angle]) {
        translate([0,outer_bench_wall_radius,0])   
            bent_seat_flow();
    }
}
*/


/*

difference() {
    for (i = [0:number_of_seats-1]) {
        rotate([0,0,(-number_of_seats/2+0.5+i)*seat_angle]) {

translate([-outer_bench_wall_radius,0,0])
translate([0,0,bench_height])
rotate([0,180,0])
translate([-bend_r,0,0])
rotate([0,0,-seat_angle/2])
bend(size = [seat_back_width, bench_height+seat_lip_height, bench_width+base_overhang+seat_overhang], angle = seat_angle, frags=bend_frags)
translate([0,bench_height,0])
rotate([90,0,0])
seat_flow();
            
        }}
rotate([0,0,90])        
base();
    }
*/

// Next steps:
// * figure out how to move to the origin + align with axis
// * scale the size of the seat so that it takes up the expected amount of space (this will likely be the same task as the above, as the radius of the bend will need to be matched). Start with this. Look at how bend.scad calculates the bend radius.

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
