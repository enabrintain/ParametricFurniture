// Parametric Standing Desk Hutch
use <text_on.scad>

$fn=360;
in2mm = 25.4;

deskWidth = 40;
deskHeight = 31;
deskDepth = 28;
woodThickness = 0.75;

crossbarDepth = 5;
bottomLegHeight = 3.5*in2mm;
roundedCornerRadius = 1;

notes = true;

//dont change these variables, theyre dependant on vars you can change
MAGICNUMBER = 6.4;
deskWidthMM = deskWidth*in2mm;
deskHeigtMM = deskHeight*in2mm;
deskDepthMM = deskDepth*in2mm;
woodThicknessMM = woodThickness*in2mm;
crossbarDepthMM = crossbarDepth*in2mm;
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
module crossBar(width=deskWidthMM, thickness=woodThicknessMM,depth = crossbarDepthMM)
{
    difference()
    {
        roundedRect([width, depth, thickness], roundedCornerRadiusMM);
        //origin side
        translate([roundedCornerRadiusMM,0,0])
        cube([thickness, thickness, thickness]);        
        translate([roundedCornerRadiusMM,depth-thickness,0])
        cube([thickness, thickness, thickness]);
        //other side
        translate([width-roundedCornerRadiusMM-thickness,0,0])
        cube([thickness, thickness, thickness]);
        translate([width-roundedCornerRadiusMM-thickness,depth-thickness,0])
        cube([thickness, thickness, thickness]);
    }
    
    if(notes)
    {
        echo ("");
        echo ("********* NOTES **********");
        echo (str("The internal width (between tabs) of crossBar is ",
            (width-(roundedCornerRadiusMM+thickness)*2)/in2mm), " inches.");
        echo ("");
        echo ("");
    }
}




module back(width=deskWidthMM, thickness=woodThicknessMM, height=deskHeigtMM)
{
    difference()
    {
        cube([width, height, thickness]);
        
        //remove large rectangles
        translate([0,bottomLegHeight,0])
            cube([width*.28, height*.7, thickness]); // origin
        translate([width-(width*.28),bottomLegHeight,0])
            cube([width*.28, height*.7, thickness]); // origin
        
        //bottom tab part
        translate([roundedCornerRadiusMM,0,0])
            cube([thickness, thickness*2, thickness]); // origin
        translate([width-roundedCornerRadiusMM-thickness,0,0])
            cube([thickness, thickness*2, thickness]); // origin
        
        // bottom tab cutout
        translate([0,(thickness*2)+roundedCornerRadiusMM,0])
            cube([roundedCornerRadiusMM+thickness, bottomLegHeight, thickness]);
        translate([width-roundedCornerRadiusMM-thickness,(thickness*2)+roundedCornerRadiusMM,0])
            cube([roundedCornerRadiusMM+thickness, bottomLegHeight, thickness]);
        
        
        //top tab part
        translate([roundedCornerRadiusMM,bottomLegHeight+(height*.7),0])
            cube([thickness, thickness*2, thickness]); // origin
        translate([width-roundedCornerRadiusMM-thickness,bottomLegHeight+(height*.7),0])
            cube([thickness, thickness*2, thickness]); // origin
            
        // bottom tab cutout
        translate([0,(thickness*2)+roundedCornerRadiusMM+bottomLegHeight+(height*.7),0])
            cube([roundedCornerRadiusMM+thickness, height*.3-bottomLegHeight, thickness]);
        translate([width-roundedCornerRadiusMM-thickness,(thickness*2)+roundedCornerRadiusMM+bottomLegHeight+(height*.7),0])
            cube([roundedCornerRadiusMM+thickness, height*.3-bottomLegHeight, thickness]);
        
        
        // cord hole
        translate([(width/2)-2*in2mm, 0, 0])
        linear_extrude(height=thickness)
            hull()
            {
                translate([roundedCornerRadiusMM*2,5*in2mm,0])
                circle(r=roundedCornerRadiusMM*1.5);// origin + x & y
                square([4*in2mm, 1]);
            }
            
            
        //loops for back slots
        for (yOffset =[in2mm*2:(4*in2mm):height-in2mm*2])
        {
            echo(str("back: translate([", width*.33, ",yOffset,0])"));
            color("blue")
            translate([width*.33,yOffset,0])
                cube([3*in2mm, 2*in2mm, thickness]);
            color("blue")
            translate([width-(width*.33)-(3*in2mm),yOffset,0])
                cube([3*in2mm, 2*in2mm, thickness]);
        }
    }
    
    
    if(notes)
    {
        echo ("");
        echo ("********* NOTES **********");
        echo (str("There are ",
            floor(((height-in2mm*2)-in2mm*2)/(3*in2mm))+1, " steps that are 3 inches per step."));
        echo ("");
        echo ("");
    }
}

module side(width=deskDepthMM, thickness=woodThicknessMM, height=deskHeigtMM)
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    cube([width, 1, thickness]);
                    cube([width*(2/3), height, thickness]);
                }
                
                //rounding corner
                color("white")
                translate([width*(2/3)-80,height-100,0])
                cube([200, 200, thickness]);
            }
                
            //NOTE: red is for "this wont scale nicely"
            translate([width*(2/3)-83, height-115,0])
            rotate([0,0,6])
            intersection()//intersection()
            {
                cylinder(r1=width*.16, r2=width*.16, h=thickness);
                cube([200, 200, thickness]);
            }
        }
        
        
        //slot for crossbar
        color("blue")
        translate([width-crossbarDepthMM-in2mm,0,0])
            cube([crossbarDepthMM, thickness, thickness ]); 
        
        //back slots
        color("blue")
        translate([thickness,thickness*2,0])
            cube([thickness, (thickness*2+roundedCornerRadiusMM), thickness]);
        color("blue")
        translate([thickness,bottomLegHeight+(height*.7)+thickness*2,0])
            cube([thickness, (thickness*2+roundedCornerRadiusMM), thickness]);
        
        //table slots
        for (yOffset =[in2mm*2:(4*in2mm):height-in2mm*2])
        {
            
            translate([thickness*3,yOffset,0])
            union()
            {
                color("violet")
                hull()
                {
                    cube([in2mm*2, in2mm, thickness]);
                    translate([in2mm*2.3,in2mm*2.3,,0])
                        cube([in2mm*2, in2mm, thickness]);
                }
                if(yOffset<height-(in2mm*5))
                color("pink")
                translate([in2mm*2.3,in2mm*2.3,0])
                    cube([in2mm*2,(in2mm*4),thickness]);
            }

            translate([width*(2/3)-(in2mm*5),yOffset,0])
            union()
            {
                color("violet")
                hull()
                {
                    cube([in2mm*2, in2mm, thickness]);
                    translate([in2mm*2.3,in2mm*2.3,,0])
                        cube([in2mm*2, in2mm, thickness]);
                }
                if(yOffset<height-(in2mm*5))
                color("pink")
                translate([in2mm*2.3,in2mm*2.3,0])
                    cube([in2mm*2,(in2mm*4),thickness]);
            }
        }
        
        //Middle Hole
        color("green")
        translate([in2mm*8,in2mm*2,0])
            roundedRect([width*.15, height-(in2mm*4), thickness], in2mm*.5);
    }
        
    if(notes)
    {
        echo ("");
        echo ("********* NOTES **********");
        echo (str("Back tab height is ",
            ((thickness*2+roundedCornerRadiusMM)/(in2mm)), " inches."));
        echo ("");
        echo ("");
    }
}


module shelfConnectorSideAssembly(width=deskDepthMM, thickness=woodThicknessMM, height=deskHeigtMM)
{
    simpleOffset = 0;
    
    union()
    {
        //cube([width*(2/3)-(in2mm*5)-MAGICNUMBER,simpleOffset, thickness]);
        translate([0,simpleOffset,0])
            cube([in2mm*2,thickness/2,thickness]);
        translate([width*(2/3)-(in2mm*7)-MAGICNUMBER,simpleOffset,0])
            cube([in2mm*2,thickness/2,thickness]);
        /* TODO: figure out how this hook works
        translate([(in2mm*4)+(width*.15)-MAGICNUMBER,simpleOffset,0])
            cube([in2mm,in2mm+thickness,thickness]);
        translate([(in2mm*4)+(width*.15)-MAGICNUMBER,simpleOffset+thickness,0])
            cube([in2mm*2,in2mm,thickness]);
        */
    }
}

module shelfConnectorBackAssembly(width=deskWidthMM, thickness=woodThicknessMM, height=deskHeigtMM)
{
    myWidth = width*0.44;
    myHeight = deskDepthMM*.25;
    
    cutoutWidth = width*.28;
    
    union()
    {
        difference()
        {
            cube([myWidth,myHeight, thickness]);
            //color("blue")
            translate([(myWidth/2)-(in2mm/2),deskDepthMM*.25-(in2mm*1.5),0])
                cube([in2mm, in2mm*1.5, thickness]);
            
            
        }
        translate([0, myHeight, 0])
            union()
            {
                translate([(width*.33)-cutoutWidth, 0, 0])
                    cube([3*in2mm, thickness, thickness]);
                translate([(width-(width*.33)-(3*in2mm)-cutoutWidth),0,0])
                    cube([3*in2mm, thickness, thickness]);
            }
    }
}

module bigShelf(width=(deskWidthMM-(roundedCornerRadiusMM+woodThicknessMM)*2),
                  thickness=woodThicknessMM, height=deskDepthMM*(2/3))
{
    cylinderRad = deskDepthMM*.16;
    union()
    {
        translate([0,deskDepthMM*(1/3),0])
            shortShelf();
        hull()
        {
            translate([cylinderRad,cylinderRad,0])
            cylinder(r1=cylinderRad, r2=cylinderRad, h=thickness);
            translate([width-cylinderRad,cylinderRad,0])
            cylinder(r1=cylinderRad, r2=cylinderRad, h=thickness);
            translate([0,deskDepthMM*(1/3),0])
                cube([width, 1, thickness]);
        }
    }
}
module shortShelf(width=(deskWidthMM-(roundedCornerRadiusMM+woodThicknessMM)*2),
                  thickness=woodThicknessMM, height=deskDepthMM*(2/3))
{
    shelfConnectorBackAssemblyWidth = deskWidthMM*0.44;
    shelfConnectorBackAssemblyHeight = deskDepthMM*.25;
    shelfConnectorSideAssemblyHeight = deskDepthMM*(2/3)-(in2mm*7)-MAGICNUMBER;
    union()
    {
        difference()
        {
            cube([width, height, thickness]);
            color("green")
            translate([width/2-shelfConnectorBackAssemblyWidth/2,height-shelfConnectorBackAssemblyHeight,0])
                cube([shelfConnectorBackAssemblyWidth, shelfConnectorBackAssemblyHeight,thickness]);
        }
        
        translate([width/2-shelfConnectorBackAssemblyWidth/2,height-shelfConnectorBackAssemblyHeight,0])
            shelfConnectorBackAssembly();
        translate([0,height-(shelfConnectorSideAssemblyHeight+in2mm*4), 0])
            rotate([0,0,90])
                shelfConnectorSideAssembly();
        translate([width+thickness/2,height-(shelfConnectorSideAssemblyHeight+in2mm*4), 0])
            rotate([0,0,90])
                shelfConnectorSideAssembly();
    }
}

module shelflets(width=(deskWidthMM-(roundedCornerRadiusMM+woodThicknessMM)*2),
                  thickness=woodThicknessMM, height=deskDepthMM*(2/3))
{
    difference()
    {
        shortShelf();
        color("magenta")
        translate([-woodThicknessMM/2,0,0])
        cube([(width+woodThicknessMM)/2-in2mm*1.5, height+woodThicknessMM, thickness]);
    }
}

module partsLayout()
{
    rotate([0,180,0])
    translate([deskWidthMM+in2mm*2, 0,0])
    side();
    translate([-deskWidthMM-in2mm*2-deskDepthMM, -deskHeigtMM-in2mm,0])
    side();
    translate([-deskWidthMM-in2mm, 0,0])
    back();
    translate([-deskWidthMM-in2mm,-6*in2mm,0])
    crossBar();
    translate([0,-deskDepthMM*(2/3)-in2mm-woodThicknessMM,0])
    shortShelf();
    bigShelf();
    translate([-(deskWidthMM-(roundedCornerRadiusMM+woodThicknessMM)*2)-in2mm,
    -deskDepthMM*(2/3)-(in2mm*7)-woodThicknessMM,0])
    shelflets();
}

projection(cut = false)
side();