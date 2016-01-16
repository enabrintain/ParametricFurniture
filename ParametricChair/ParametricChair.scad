//Source files Copyright 2015 by Phillip Showers, licensed under GPLv3.
//Parametric chair


$fn=360;
in2mm = 25.4;

woodThicknessInches = 0.725;

seatHeightInches = 32;
backHeightInches = 13;
seatWidthInches = 19;
seatDepthInches = 18;
topOfBackHeightInches = 50;


/**
 * PARAMETRIC VARS
 */
 
woodThickness = woodThicknessInches*in2mm;
seatHeight = seatHeightInches*in2mm;
backHeight = backHeightInches*in2mm;
seatWidth = seatWidthInches*in2mm;
seatDepth = seatDepthInches*in2mm;
topOfBackHeight = topOfBackHeightInches*in2mm;

module seat()
{
    width = seatWidth;
    backRadius = 2*in2mm;
    frontRadius = 3*in2mm;
    difference()
    {
        hull()
        {
            translate([backRadius,seatDepth-backRadius,0])
                cylinder(h=woodThickness,r=backRadius,center=false); // top left
            translate([width-backRadius,seatDepth-backRadius,0])
                cylinder(h=woodThickness,r=backRadius,center=false); // top right
            translate([frontRadius,frontRadius,0])
                cylinder(h=woodThickness,r=frontRadius,center=false); // bottom left
            translate([width-frontRadius,frontRadius,0])
                cylinder(h=woodThickness,r=frontRadius,center=false); //bottom right
        }
        //slots
        translate([woodThickness,seatDepth/4,0])
            cube([woodThickness,seatDepth/2,woodThickness]); // left
        translate([width-woodThickness*2,seatDepth/4,0])
            cube([woodThickness,seatDepth/2,woodThickness]); //right
    }
        //color("blue")cube([width,seatDepth,woodThickness]); // left
}

module side()
{
    radius = 2*in2mm;
    seatBackRadius = 4*in2mm;
    
    union()
    {
        hull()
        {
            translate([radius/2,0,0])
                cube([seatDepth-radius,seatHeight,woodThickness]);
            translate([0,radius,0])
                cylinder(h=woodThickness,r=radius,center=false); //front cylinder
            translate([seatDepth+radius*4,radius,0])
                cylinder(h=woodThickness,r=radius,center=false); //back cylinder
        }
        
        hull()
        {
            translate([seatDepth+seatBackRadius+woodThickness,topOfBackHeight-seatBackRadius*1.5,0]) 
                cylinder(h=woodThickness,r=seatBackRadius,center=false); //seat back cylinder
            translate([seatDepth+woodThickness,topOfBackHeight-3*backHeight/4,0]) color("blue")
                cube([woodThickness,seatBackRadius*2,woodThickness]);
            translate([seatDepth+radius*4,radius,0])
                cylinder(h=woodThickness,r=radius,center=false); //back cylinder
        }   
        
        //back tab
        translate([seatDepth,topOfBackHeight-3*backHeight/4,0]) color("blue")
            cube([woodThickness,backHeight/2,woodThickness]);
        //seat tab
        translate([seatDepth/4, seatHeight,0]) color("purple")
            cube([seatDepth/2,woodThickness,woodThickness]);
    }
}

module back()
{
    width = seatWidth;//-(2*woodThickness);
    radius = 4*in2mm;
    hull()
    {
        translate([radius,backHeight-radius,0])
            cylinder(h=woodThickness,r=radius,center=false); // top left
        translate([width-radius,backHeight-radius,0])
            cylinder(h=woodThickness,r=radius,center=false); // top right
        translate([radius,radius,0])
            cylinder(h=woodThickness,r=radius,center=false); // bottom left
        translate([width-radius,radius,0])
            cylinder(h=woodThickness,r=radius,center=false); // botom right
    }
}

translate([0,0,seatHeight])seat();
translate([woodThickness,0,0,])rotate([90,0,90])side();
translate([seatWidth-woodThickness*2,0,0,])rotate([90,0,90])side();//*/
translate([0,seatDepth+woodThickness,topOfBackHeight-backHeight])rotate([90,0,0])back();

//TODO make the sides hollow 
//TODO add cross braces
