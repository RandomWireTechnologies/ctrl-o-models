//////////////////
//Parameters
//////////////////
$fn = 100;
window_depth = 1.6;
window_diameter = 20;
window_lip_depth = 1;
window_lip_width = 3;
wall_thickness = 4;
cover_diameter = 78;
cover_height = 19;
board_width = 41;
board_height = 43.4;
board_thickness = 4;
board_x_shift = 2;
board_y_shift = 4.5;
led_diameter = 5;

///////////////////
// renders
///////////////////

//base_plate();
rfid_cover(cover_diameter,cover_height);
//rfid_window(window_diameter,window_depth,window_lip_width,window_lip_depth);

// modules


module rfid_window(window_diameter,window_depth,lip_width,lip_thick) {
	cylinder(d=window_diameter,h=window_depth);
	translate([0,0,window_depth]) cylinder(d=(2*lip_width+window_diameter),h=lip_thick);

}

module rfid_cover(diameter,height) {
	front_height = window_depth+window_lip_depth;
   inner_height = height-(front_height+board_thickness);
   inner_diameter = (diameter-(2*wall_thickness));
   difference() {
		cylinder(d=diameter,h=height);
		translate([0,0,(front_height+board_thickness)]) 
			cylinder(d=inner_diameter,h=inner_height+.1);
		translate([0,0,window_depth])
			cylinder(d=(window_diameter+window_lip_width),h=window_lip_depth+.1);
		translate([0,0,0])
			cylinder(d=(window_diameter),h=window_depth+.1);
		translate([-(board_x_shift+board_width/2),-(board_y_shift+board_height/2),front_height])
			cube([board_width,board_height,board_thickness]);
		translate([0,((cover_diameter/4)+(window_diameter/4)),0])
			cylinder(d=led_diameter,h=(front_height+board_thickness+.1));
	}

}
