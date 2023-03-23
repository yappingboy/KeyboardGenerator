include <includes.scad>

fast=false;
mirrored=false; // -interfaceThickness
wire_gauge=1; // the diameter of the wiring
diode_gauge=1; //diameter if the diode wiring
unit=19; //default unit for keyboards is 19mm
grid=1.27;
switchpinlength=3.5;
nozzleDia=.8;
length=len(keys);
standoffThickness=2; // the thickness of the wall around the bottom
standoffheight=5; //height of the wall
plateThickness=5;
interfaceThickness=1;
switchDim=14;
board(false,keys,length,fast);



module trunkPyramid(topsize=14, bottomsize=15, height=5)
{
TrunkPoints = [
  [ -bottomsize/2,  -bottomsize/2,  -height/2 ],  //0
  [ bottomsize/2,  -bottomsize/2,  -height/2 ],  //1
  [ bottomsize/2,  bottomsize/2,  -height/2 ],  //2
  [ -bottomsize/2,  bottomsize/2,  -height/2 ],  //3
  [ -topsize/2,  -topsize/2,  height/2 ],  //4
  [ topsize/2,  -topsize/2,  height/2 ],  //5
  [ topsize/2,  topsize/2,  height/2 ],  //6
  [ -topsize/2,  topsize/2,  height/2 ]]; //7
  
TrunkFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
polyhedron( TrunkPoints, TrunkFaces);
}

module board(mirrored,keys,length, fast)
{
    side= mirrored ? -1 : 1;
    echo(side);
    union()
    {
        //array of sockets
        for(index=[0:length-1])
        {
            if(!fast)
            {
                translate([(unit*keys[index][1][0]),-(unit*keys[index][1][1]),(unit*keys[index][1][2])])
                    rotate([0,0,-keys[index][1][3]])
                        translate([unit/2,-unit/2,0])
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])])
                            {
                                    hss($fn=32,grid=grid,diode_gauge_mm=diode_gauge,wire_gauge_mm=wire_gauge,hzExpComp=1.15,sideslots=false);
                            }
            }
        }

        difference()
        {
            //main plate
            union()
            {
                for(index=[0:length-1])
                {
                    translate([(unit*keys[index][1][0]),-(unit*keys[index][1][1]),(unit*keys[index][1][2])])
                    {
                        rotate([0,0,-keys[index][1][3]])
                            translate([unit/2,-unit/2,0])
                        {
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])+switchpinlength/4])
                            {
                                color("green")  
                                    cube([unit,unit,switchpinlength/2],center=true);
                            }
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])+(wire_gauge/2)+((3.5-wire_gauge)/2)-(standoffheight+(3.5-wire_gauge))/2])
                            {
                                color("red")    
                                    cube([unit+(standoffThickness*2),unit+(standoffThickness*2),(standoffheight+(3.5-wire_gauge))],center=true);
                            }
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])+plateThickness/2+(wire_gauge/2)+((3.5-wire_gauge)/2)])
                            {
                                color("orange") 
                                    trunkPyramid(unit,unit+(standoffThickness*2),plateThickness);
                            }
                        }
                    }
               }
            }
            
            union()
            {
                for(index=[0:length-1])
                {
                    translate([(unit*keys[index][1][0]),-(unit*keys[index][1][1]),(unit*keys[index][1][2])])
                    {
                        rotate([0,0,-keys[index][1][3]])
                            translate([unit/2,-unit/2,0])
                        {
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])])
                            {
                                color("white")
                                {
                                    cube([grid*11,grid*11,5],center=true);
                                    translate([-((3*grid)-(wire_gauge*1.3/2)),0,0])
                                        rotate([90,0,0]) 
                                            //cylinder(d=(wire_gauge*1.1*1.3),h=unit+(2*standoffThickness),center=true);
                                            cube([(wire_gauge*1.1*1.3),(wire_gauge*1.1*1.3),unit+(2*standoffThickness)+.1],center=true);
                                }
                            }
                        }
                    }
                    translate([(unit*keys[index][1][0]),-(unit*keys[index][1][1]),(unit*keys[index][1][2])])
                    {
                        rotate([0,0,-keys[index][1][3]])
                            translate([unit/2,-unit/2,0])
                        {
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])+(wire_gauge/2)+((3.5-wire_gauge)/2)-(standoffheight+(3.5-wire_gauge))/2-wire_gauge*2])
                            {
                                color("blue")
                                    cube([unit,unit,(standoffheight+(3.5)-(wire_gauge*1.1*1.3))+1],center=true);
                            }
                            translate([(unit*keys[index][0][0]),-(unit*keys[index][0][1]),(keys[index][0][2])+plateThickness/2+(wire_gauge/2)+((3.5-wire_gauge)/2)])
                            {
                            color("yellow")
                                translate([0,0,-interfaceThickness/2])
                                        cube([unit-nozzleDia,unit-nozzleDia,plateThickness-interfaceThickness],center=true);
                                cube([switchDim,switchDim,plateThickness+1],center=true);
                            }
                        }
                    }
                }
            }
        }
    }
}