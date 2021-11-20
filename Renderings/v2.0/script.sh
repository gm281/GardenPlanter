#!/bin/bash

cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/0/g" > /tmp/script0.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/1/g" > /tmp/script1.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/2/g" > /tmp/script2.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/3/g" > /tmp/script3.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/4/g" > /tmp/script4.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/5/g" > /tmp/script5.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/6/g" > /tmp/script6.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/7/g" > /tmp/script7.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/8/g" > /tmp/script8.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/9/g" > /tmp/script9.scad;   
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/10/g" > /tmp/script10.scad; 
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/11/g" > /tmp/script11.scad; 
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/12/g" > /tmp/script12.scad; 
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/13/g" > /tmp/script13.scad; 
cat garden-planter-bench.scad | sed -e "s/SLICE_COUNT/30/g" -e "s/SLICE_IDX/14/g" > /tmp/script14.scad; 

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/0.svg /tmp/script0.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/1.svg /tmp/script1.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/2.svg /tmp/script2.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/3.svg /tmp/script3.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/4.svg /tmp/script4.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/5.svg /tmp/script5.scad   &
echo "Waiting for 6"
wait

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/6.svg /tmp/script6.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/7.svg /tmp/script7.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/8.svg /tmp/script8.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/9.svg /tmp/script9.scad   &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/10.svg /tmp/script10.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/11.svg /tmp/script11.scad &
echo "Waiting for 12"
wait

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/12.svg /tmp/script12.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/13.svg /tmp/script13.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Renderings/14.svg /tmp/script14.scad &

echo "Waiting for 15"
wait
