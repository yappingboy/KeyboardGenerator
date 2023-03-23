//hss(wire_gauge_mm=1,diode_gauge_mm=.75,sideslots=false);
module hss($fn=64,grid=1.27,diode_gauge_mm=0.508,wire_gauge_mm=0.559,hzExpComp=1.15,sideslots=true)
{
    pin2 = [-2*grid, 4*grid, 1.5];
    pin1 = [3*grid, 2*grid, 1.5];

    stem = [0, 0, 3.80];
    peg1 = [-4*grid, 0, 2.1];
    peg2 = [4*grid, 0, 2.1];
    base = [11*grid, 11*grid, 3.5];

    diode_dia = diode_gauge_mm * 0.98;
    wire_dia = wire_gauge_mm ;

    diode_angle = -6;

    // diode_mock();
 //       row_channel(base,diode_dia,pin2);
    rotate([0,180,0])
        difference(){
            make_body(base, stem, peg1, peg2, pin1, pin2,sideslots);
        
            column_channel(base,wire_dia,pin1);
            row_channel(base,diode_dia,pin2,wire_dia);
            
            //translate([0,-base[1]/4,base[2]/4])
            //    cube([base[0],base[1]/2,base[2]/2],center=true);
            //left_pin_wire_slots(grid, diode_dia, wire_dia, base);
        
            //right_pin_wire_slots(pin1,grid,base,wire_dia);
        
            //diode_slot(grid, diode_angle,diode_dia,base);
        }
}
module make_body(base, stem, peg1, peg2, pin1, pin2,sideslots){
    difference(){
        translate([0, 0, 0]){
            cube([base.x, base.y, base.z], center = true);
        }

        if(sideslots)
        {
            // Side Slots for removal
            translate([7.75, 0, 0])
                rotate([0, 45, 0])
                    cube([2, 20, 2], center = true);

            translate([-7.75, 0, 0])
                rotate([0, 45, 0])
                    cube([2, 20, 2], center = true);

            translate([0, 7.75, 0])
                rotate([45, 0, 0])
                    cube([20, 2, 2], center = true);

            translate([0, -7.75, 0])
                rotate([45, 0, 0])
                    cube([20, 2, 2], center = true);
        }
        // Main Stem Clamp
        translate([stem.x, stem.y, 0]){
            cylinder(h=base.z*2, d=stem[2], center = true);
        }

        translate([0, -5, 0]){
            cube([3, 10, base.z*2], center = true);
        }

        // PCB Mount Pegs
        translate([peg1.x, peg1.y, 0]){
            cylinder(h=base.z*2, d=peg1[2], center = true);
        }

        translate([peg2.x, peg2.y, 0]){
            cylinder(h=base.z*2, d=peg2[2], center = true);
        }

        // Switch Pins
        translate([pin2.x, pin2.y, 0]){
            cylinder(h=base.z*2, d=pin2[2], center = true);
        }

        translate([pin1.x, pin1.y, 0]){
            cylinder(h=base.z*2, d=pin1[2], center = true);
        }

    }
}
//end
module column_channel(base,wire_dia,pin)
{
    channelwidth=wire_dia*1.3;
    translate([pin[0]-channelwidth/2,0,0])//-base[2]/4
        rotate([90,0,0])
            cylinder(h=base[0]+1,d=channelwidth,center=true);
}

module row_channel(base,diode_dia,pin,wire_dia)
{
    channelwidth=diode_dia*1.5;
    union()
    {
        translate([0,pin[1],base[2]/2])
            rotate([0,90,0])
            {
            translate([0,0,base[0]/4])
                cylinder(h=base[0]/2+1,d=channelwidth,center=true);
            cube([2.1,2.5,4],center=true);
            translate([-.4,0,-pin[1]+(pin[2]+1)/2])
                cube([channelwidth,channelwidth,pin[2]*2+1],center=true);
            translate([base[2]-channelwidth,0,-pin[1]+(pin[2]+1)/2])
                cube([channelwidth,channelwidth,pin[2]*2+1],center=true);
            }
        translate([pin[0]-pin[2]-1,pin[1],0])
            cylinder(h=base[2]+1,d=pin[2],center=true);
        translate([0,base[1]/2,base[2]/2])
            rotate([0,90,0])
                cylinder(h=base[1]+1,d=wire_dia,center=true);
    }
}

module left_pin_wire_slots(grid, diode_dia, wire_dia, base){
    // Diode Pin Wire Channels
    translate([-2*grid, 5*grid, 0])
        cube([1.5*diode_dia, 3, base.z*2], center = true);

    translate([-4*grid, 4.5*grid, -base.z/2])
        cube([5, 1.25*diode_dia, 3*diode_dia], center = true);

    translate([-5.25*grid, 4.5*grid, 0])
        cube([1, 1.25*diode_dia, base.z*2], center = true);

    translate([0, -4*grid, base.z/2])
        cube([20, wire_dia, base.z], center = true);
    
    translate([-5.25*grid, -4*grid, 0])
        cube([1, wire_dia, base.z*2], center = true);
    
    translate([-4*grid, -4*grid, -base.z/2])
        cube([4, wire_dia, 3*diode_dia], center = true);

}

module right_pin_wire_slots(pin1,grid,base,wire_dia){
    translate([pin1.x, 4*grid, -base.z/2])
        cube([1.2*wire_dia, 4*grid, 3*wire_dia], center = true);
    translate([pin1.x, 5.5*grid, 0])
        cube([1.2*wire_dia, 2, base.z], center = true);
}

module diode_slot(grid, diode_angle,diode_dia,base){
    union(){
        // Diode Body + Other Leg
        translate([-2.45*grid, -1.5*grid, -0.75])
            rotate([0, 0, diode_angle]){
                cube([2.0, 3.5, 2.1], center = true);
            }
        translate([-2.45*grid, -1.5*grid, -base.z/2])
            rotate([0, 0, diode_angle]){
                translate([0, 2, 0])
                    cube([diode_dia, 11, 2.5], center = true);
                translate([0, -3.25, 0])
                    cylinder(h=2.5, d=1.75, center = true);
            }
    }
}

module diode_mock(){
    translate([-2.45*grid, -1.5*grid, -0.75])
        rotate([0, 0, diode_angle])
            rotate([90, 0, 0]){
                cylinder(h=3.2, d=2, center = true);
                cylinder(h=100, d=diode_dia, center = true);
            }
}