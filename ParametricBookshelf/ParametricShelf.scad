
$fn=360;
in2mm = 25.4;

shelfWidthInches = 18;
woodThicknessInches = 0.725;
numShelves = 7;
shelfBaseDepthInches = 12;
shelfTopDepthInches = 9;
woodThicknessInches = 0.725;

/**
 * PARAMETRIC VARS
 */
 
woodThickness = woodThicknessInches*in2mm;
shelfWidth = shelfWidthInches*in2mm;
shelfTopDepth = shelfTopDepthInches*in2mm;
shelfBaseDepth = shelfBaseDepthInches*in2mm;
shelfHeight = (numShelves*(12+woodThicknessInches)+woodThicknessInches)*in2mm;

module genericShape()
{
    hull()
    {
        color("blue")
        translate([0,(shelfBaseDepth-shelfTopDepth),shelfHeight])
            cube([shelfWidth, shelfTopDepth, woodThickness]);
        cube([shelfWidth, shelfBaseDepth, woodThickness]);
    }
}

/*module base()
{
    translate([woodThickness,0,0])
        cube([shelfWidth-(woodThickness*2), shelfBaseDepth-woodThickness, woodThickness]);
    //tabs
    translate([0,shelfBaseDepth/4,0])
        cube([woodThickness, shelfBaseDepth/2, woodThickness]);
    translate([shelfWidth-woodThickness,shelfBaseDepth/4,0]) 
        cube([woodThickness, shelfBaseDepth/2, woodThickness]);
    translate([(shelfWidth/4),shelfBaseDepth-woodThickness,0]) 
        cube([shelfWidth/2, woodThickness, woodThickness]);//back tab
    
}//*
module top()
{
    
    color("green")
    translate([woodThickness,0,0])
        cube([shelfWidth-(woodThickness*2), shelfTopDepth-woodThickness, woodThickness]);
    
    //tabs
    translate([0,shelfTopDepth/4,0])
        cube([woodThickness, shelfTopDepth/2, woodThickness]);
    translate([shelfWidth-woodThickness,shelfTopDepth/4,0]) 
        cube([woodThickness, shelfTopDepth/2, woodThickness]);
    translate([(shelfWidth/4),shelfTopDepth-woodThickness,0]) 
        cube([shelfWidth/2, woodThickness, woodThickness]); //back tab
}//*/

module side()
{
    difference()
    {
        hull()
        {
            color("blue")
            translate([0,(shelfBaseDepth-shelfTopDepth),shelfHeight-woodThickness])
                cube([woodThickness, shelfTopDepth, woodThickness]);
            cube([woodThickness, shelfBaseDepth, woodThickness]);
        }
        
        //tabs
        color("blue")
        translate([0,shelfBaseDepth/4,0])
            cube([woodThickness, shelfBaseDepth/2, woodThickness]); //bottom tab
        color("blue")
        translate([0,(shelfBaseDepth-shelfTopDepth)+shelfTopDepth/4,shelfHeight-woodThickness])
            cube([woodThickness, shelfTopDepth/2, woodThickness]); //top tab
        
        color("blue")
        translate([0,shelfBaseDepth-woodThickness,shelfHeight/12])
            cube([woodThickness, woodThickness, shelfHeight/6]); //bottom side tab
        color("blue")
        translate([0,shelfBaseDepth-woodThickness,shelfHeight*9/12])
            cube([woodThickness, woodThickness, shelfHeight/6]); //top side tab
        
        shelfGenerator();
    }
}

module back()
{
    difference()
    {
        union()
        {
            translate([woodThickness,0,0])
                cube([shelfWidth-(woodThickness*2), woodThickness, shelfHeight]);
            
            //side tabs
            color("blue")
            translate([0,0,shelfHeight/12])
                cube([woodThickness, woodThickness, shelfHeight/6]);
            color("blue")
            translate([0,0,shelfHeight*9/12])
                cube([woodThickness, woodThickness, shelfHeight/6]);
            color("blue")
            translate([shelfWidth-woodThickness,0,shelfHeight/12])
                cube([woodThickness, woodThickness, shelfHeight/6]);
            color("blue")
            translate([shelfWidth-woodThickness,0,shelfHeight*9/12])
                cube([woodThickness, woodThickness, shelfHeight/6]);
        }
        translate([0,-(shelfBaseDepth-woodThickness-1),0])
            shelfGenerator();
    }
}

module shelfGenerator(translateFlag = true, layoutFlag = false)
{
    
    diffDepth = shelfBaseDepth-shelfTopDepth;
    color("purple")
    if(!layoutFlag)
    {
        for (zOffset =[0:(12*in2mm)+woodThickness:shelfHeight])
            {
                depth = shelfTopDepth+((shelfHeight-zOffset) * (diffDepth/shelfHeight));
                
                echo (str(depth/in2mm));
                echo (str(shelfTopDepth/in2mm, "+ ((", shelfHeight/in2mm, "-", zOffset/in2mm, ")*(", diffDepth/in2mm, "/", shelfHeight/in2mm, ")" ));
                
                translate([0,0,zOffset])
                    shelf(depth, translateFlag);
            }
    }
    else
    {
        recursiveShelf(2*in2mm, 0);
    }
    echo (str("sin() = (", shelfBaseDepth/in2mm, "-", shelfTopDepth/in2mm, ")/", str(shelfHeight/in2mm)));// );
}

module recursiveShelf(yOffset, zOffset)
{
    diffDepth = shelfBaseDepth-shelfTopDepth;
    depth = shelfTopDepth+((shelfHeight-zOffset) * (diffDepth/shelfHeight));
    translate([0,yOffset,0]) shelf(depth, true);
    echo (str("depth=", depth/in2mm));
    echo (str("yOffset=", yOffset));
    if(zOffset<shelfHeight)
        recursiveShelf(yOffset+ depth + in2mm, zOffset+((12*in2mm)+woodThickness));
}

module shelf(depth=shelfTopDepth, moveBack = false)
{
    if(moveBack)
    {
        translate([0,shelfBaseDepth-depth,0])
            union()
            {
                translate([woodThickness,0,0])
                    cube([shelfWidth-(woodThickness*2), depth-woodThickness, woodThickness]);
                
                //tabs
                translate([0,depth/4,0])
                    cube([woodThickness, depth/2, woodThickness]);
                translate([shelfWidth-woodThickness,depth/4,0]) 
                    cube([woodThickness, depth/2, woodThickness]);
                translate([(shelfWidth/4),depth-woodThickness,0]) 
                    cube([shelfWidth/2, woodThickness, woodThickness]); //back tab
            }
    }
    else
        union()
            {
                color("green")
                translate([woodThickness,0,0])
                    cube([shelfWidth-(woodThickness*2), depth-woodThickness, woodThickness]);
                
                //tabs
                translate([0,shelfTopDepth/4,0])
                    cube([woodThickness, shelfTopDepth/2, woodThickness]);
                translate([shelfWidth-woodThickness,shelfTopDepth/4,0]) 
                    cube([woodThickness, shelfTopDepth/2, woodThickness]);
                translate([(shelfWidth/4),shelfTopDepth-woodThickness,0]) 
                    cube([shelfWidth/2, woodThickness, woodThickness]); //back tab
            }
}


module assembled()
{
    translate([0,0,0])  side();
    translate([shelfWidth-woodThickness,0,0])  side();
    translate([0,shelfBaseDepth-woodThickness,0])   back();
    translate([0,0,0]) shelfGenerator();
}

module exploded()
{
    translate([-20,0,0])  side();
    translate([shelfWidth-woodThickness+20,0,0])  side();
    translate([0,shelfBaseDepth-woodThickness+20,0])   back();
    translate([0,0,0]) shelfGenerator();
}

module flatLayout_sheet1()
{
    //color("gray") translate([0,0,0])  cube([4*12*in2mm,8*12*in2mm,1]);
    rotate([0,-90,-90]) translate([0,shelfWidth-130,(2*in2mm)]) side();
    rotate([90,-90,0]) translate([0,-shelfWidth+105,-shelfHeight-(2*in2mm)])    side();
    rotate([-90,0,0]) translate([shelfWidth+200,-woodThickness,(2*in2mm)]) back();
}

module flatLayout_sheet2()
{
    //color("gray") translate([0,0,0])  cube([4*12*in2mm,8*12*in2mm,1]);
    shelfGenerator(layoutFlag = true);
}



//projection(cut = false) flatLayout_sheet1();
projection(cut = false) flatLayout_sheet2();
//assembled();
//exploded();
echo(str(woodThickness));