// Parametric Standing Desk Hutch
$fn=360;
in2mm = 25.4;

deskWidth = 40;
woodThickness = 0.75;

roundedCornerRadius = 1;

//dont change these variables, theyre dependant on vars you can change
deskWidthMM = deskWidth*in2mm;
woodThicknessMM = woodThickness*in2mm;
roundedCornerRadiusMM = roundedCornerRadius*in2mm;

module roundedRect(size, radius)
{
    x = size[0];
    y = size[1];
    z = size[2];
    linear_extrude(height=z)
        hull()
        {
            // place 4 circles in the corners, with the given radius
            translate([radius, radius, 0])
            //translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
            circle(r=radius);// origin

            translate([x-radius, radius, 0])
            circle(r=radius);// origin + x

            translate([radius, y-radius, 0])
            circle(r=radius);// origin + y

            translate([x-radius, y-radius, 0])
            circle(r=radius);// origin + x & y
        }
}


/***************************************************************************
* small crossbar for stabilizing the walls
***************************************************************************/
module crossBar(width=deskWidthMM, thickness=woodThicknessMM,depth = 5*in2mm)
{
    difference()
    {
        roundedRect([width, depth, thickness], roundedCornerRadiusMM);
        //origin side
        translate([roundedCornerRadiusMM+thickness,0,0])
        cube([thickness, thickness, thickness]);        
        translate([roundedCornerRadiusMM+thickness,depth-thickness,0])
        cube([thickness, thickness, thickness]);
        //other side
        translate([width-roundedCornerRadiusMM-thickness*2,0,0])
        cube([thickness, thickness, thickness]);
        translate([width-roundedCornerRadiusMM-thickness*2,depth-thickness,0])
        cube([thickness, thickness, thickness]);
    }
}



crossBar();