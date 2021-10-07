function ai_idx_float(array, idx, max_idx) = (len(array)-1)*idx/(max_idx-1);
function ai_low_idx(array, idx, max_idx) = (floor(ai_idx_float(array, idx, max_idx)) >= len(array)-1) ? floor(ai_idx_float(array, idx, max_idx))-1 : floor(ai_idx_float(array, idx, max_idx));
function ai_a(array, idx, max_idx) = ai_idx_float(array, idx, max_idx) - ai_low_idx(array, idx, max_idx);
function ai_low(array, idx, max_idx) = array[ai_low_idx(array, idx, max_idx)];
function ai_high(array, idx, max_idx) = array[ai_low_idx(array, idx, max_idx)+1];

function array_interpolate(array, index, max_index) = 
(1-ai_a(array, index, max_index))*ai_low(array, index, max_index) + ai_a(array, index, max_index)*ai_high(array, index, max_index);
 
module circularWall(radius, width, depth, height_array, start_angle=0, end_angle=360) {
    number_of_elements_float = 2*PI*(radius+depth/2)*(end_angle-start_angle) / (360*width);
    number_of_elements = floor(number_of_elements_float);
    echo("Number of elements: ", number_of_elements);
    // what is the real angle the integer number of elements will cover
    real_total_angle=(end_angle - start_angle) * number_of_elements / number_of_elements_float;
    real_start_angle=(start_angle+end_angle-real_total_angle)/2;
    real_end_angle=(start_angle+end_angle+real_total_angle)/2;
    for (i = [0:number_of_elements-1]) {
        fi=real_total_angle*(i+0.5)/number_of_elements+real_start_angle;
        height=array_interpolate(height_array, i, number_of_elements);
        echo("Element idx: ", i, ", height: ", height);
        translate([-radius*cos(fi), radius*sin(fi), height/2]) {
            rotate([0, 0, -fi]) {
                cube([depth,width*1.0,height], center=true);
            }
        }
    }
}

module cutCircularWall(radius, cut_radius, radius, width, depth, height_array, cut_displacement) {
    cut_y=-(-cut_radius*cut_radius + radius*radius + cut_displacement*cut_displacement)/(2*cut_displacement);
    cut_x=sqrt(radius*radius - cut_y*cut_y);
    half_cut_angle=(cut_displacement*cut_displacement + cut_radius*cut_radius > radius*radius) ? asin(cut_x/cut_radius) : 180-asin(cut_x/cut_radius);
    echo("Half cut angle: ", half_cut_angle);

    translate([0,-cut_displacement,0]) {
        circularWall(cut_radius, width, depth, height_array, 90-half_cut_angle, 90+half_cut_angle);
    }
}

module benchWall(width, depth, height_array, radius, y_displacement, half_angle) {
    translate([-radius*sin(half_angle),-y_displacement+radius*cos(half_angle),0]) {
        rotate([0,0,half_angle]) {
            translate([0,width,0]) {
                h = height_array[0];
                translate([0,0,h/2]) {
                cube([depth,width*1.0,height_array[0]], center=true);
                }
                h2 = height_array[len(height_array)-1];

                translate([0,-width,h2/2]) {
                    cube([depth,width*1.0,h2], center=true);
                }
            }
        }
    }
}

radius=4040/2;
width=200;
depth=100;
bench_width=450;
cut_radius=radius+bench_width-350;
cut_displacement=cut_radius-1000;
bench_wall_angle=50.75;

function _multi_array_interpolation(multi_array, current_multi_array_index, desired_index) =
    (desired_index < multi_array[current_multi_array_index][2]) ?
        array_interpolate([multi_array[current_multi_array_index][0], multi_array[current_multi_array_index][1]], desired_index, multi_array[current_multi_array_index][2]) : 
        _multi_array_interpolation(multi_array, current_multi_array_index+1, desired_index+1-multi_array[current_multi_array_index][2]);
    
function multi_array_interpolation(multi_array, index) =
    _multi_array_interpolation(multi_array, 0, index);
   
/* 35 */
back_wall_multi_array=[
    [50, 50, 8],
    [50, 100, 2],
    [75, 280, 2],
    [290, 850, 6],
    [850, 1500, 41],
    [280,280,2],
    [100,100,2],
//    [850, 1500, 35],
//    [1500, 1480, 2],
//    [1450, 1420, 2],
//    [1420, 1320, 2],
//    [1320, 1150, 2],
//    [1200, 100, 4],
//    [100, 50, 2],
    [50, 50, 100]
];

function back_wall_interpolation(index) =
    multi_array_interpolation(back_wall_multi_array, index);


height_array=[
back_wall_interpolation(0),
back_wall_interpolation(1),
back_wall_interpolation(2),
back_wall_interpolation(3),
back_wall_interpolation(4),
back_wall_interpolation(5),
back_wall_interpolation(6),
back_wall_interpolation(7),
back_wall_interpolation(8),
back_wall_interpolation(9),
back_wall_interpolation(10),
back_wall_interpolation(11),
back_wall_interpolation(12),
back_wall_interpolation(13),
back_wall_interpolation(14),
back_wall_interpolation(15),
back_wall_interpolation(16),
back_wall_interpolation(17),
back_wall_interpolation(18),
back_wall_interpolation(19),
back_wall_interpolation(20),
back_wall_interpolation(21),
back_wall_interpolation(22),
back_wall_interpolation(23),
back_wall_interpolation(24),
back_wall_interpolation(25),
back_wall_interpolation(26),
back_wall_interpolation(27),
back_wall_interpolation(28),
back_wall_interpolation(29),
back_wall_interpolation(30),
back_wall_interpolation(31),
back_wall_interpolation(32),
back_wall_interpolation(33),
back_wall_interpolation(34),
back_wall_interpolation(35),
back_wall_interpolation(36),
back_wall_interpolation(37),
back_wall_interpolation(38),
back_wall_interpolation(39),
back_wall_interpolation(40),
back_wall_interpolation(41),
back_wall_interpolation(42),
back_wall_interpolation(43),
back_wall_interpolation(44),
back_wall_interpolation(45),
back_wall_interpolation(46),
back_wall_interpolation(47),
back_wall_interpolation(48),
back_wall_interpolation(49),
back_wall_interpolation(50),
back_wall_interpolation(51),
back_wall_interpolation(52),
back_wall_interpolation(53),
back_wall_interpolation(54),
back_wall_interpolation(55),
back_wall_interpolation(56),
back_wall_interpolation(57),
back_wall_interpolation(58),
back_wall_interpolation(59),
back_wall_interpolation(60),
back_wall_interpolation(61),
back_wall_interpolation(62),
back_wall_interpolation(63),
back_wall_interpolation(64)
    ];
circularWall(radius, width, depth, height_array ,-90, 270);
cutCircularWall(radius, cut_radius, radius, width, depth, [850,850], cut_displacement);
echo("Bench walls center offset: ", cut_displacement);
echo("Outer bench wall radius: ", cut_radius);
front_wall_height_array=[400, 400, 400, 400,
                         400, 400, 400, 400,
                         400, 400, 400, 400,
                         400, 400, 400, 400];
echo("Inner bench wall radius: ", cut_radius-bench_width);
cutCircularWall(radius, cut_radius-bench_width, radius, width, depth, front_wall_height_array, cut_displacement);
bench_height_array=[550,550];
//benchWall(width, depth, bench_height_array, cut_radius-bench_width+width/2+depth/2, cut_displacement, bench_wall_angle);
//benchWall(width, depth, bench_height_array, cut_radius-bench_width+width/2+depth/2, cut_displacement, -bench_wall_angle);


