//////////////////
//Parameters
//////////////////
$fn = 100;
window_depth = 1.6;
window_diameter = 25;
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
led_diameter = 5.0;
circle_kerf = 0.3;
back_ring_height = 10;
back_ring_width = 10;
back_top_notch_width = 10;
back_top_notch_height = 6;
back_bottom_notch_width = 10;
back_bottom_notch_height = 10;
screw_hole_diameter = 3;
screw_offset = 5;


///////////////////
// renders
///////////////////

//base_plate();
rfid_cover(cover_diameter,cover_height);
//rotate(a=180,v=[1,0,0]) 
//rfid_window(window_diameter-circle_kerf,window_depth,window_lip_width-(circle_kerf/2),window_lip_depth);

// modules


module rfid_window(window_diameter,window_depth,lip_width,lip_thick) {
	cylinder(d=window_diameter,h=window_depth);
	translate([0,0,window_depth]) cylinder(d=(2*lip_width+window_diameter),h=lip_thick);

}

module rfid_cover(diameter,height) {
	front_height = window_depth+window_lip_depth;
   inner_height = height-(front_height+board_thickness);
   inner_diameter = (diameter-(2*wall_thickness));
	inner_back_diameter = (diameter-(back_ring_width*2));
   difference() {
		cylinder(d=diameter,h=height);
		translate([0,0,(front_height+board_thickness)]) 
			cylinder(d=inner_diameter,h=inner_height+.1);
		translate([0,0,window_depth])
			cylinder(d=(window_diameter+(window_lip_width*2)+circle_kerf),h=window_lip_depth+.1);
		translate([0,0,0])
			cylinder(d=(window_diameter+circle_kerf),h=window_depth+.1);
		translate([-(board_x_shift+board_width/2),-(board_y_shift+board_height/2),front_height])
			cube([board_width,board_height,board_thickness]);
		translate([0,((cover_diameter/4)+(window_diameter/4)),0])
			cylinder(d=(led_diameter+circle_kerf),h=(front_height+board_thickness+.1));
	}
	difference() {
		// More base meat for transition
		translate([0,0,height])
			cylinder(d=diameter,h=back_ring_height);
		// Remove a cone section to make swept walls
		translate([0,0,height])
			cylinder(d1=inner_diameter,d2=inner_back_diameter,h=back_ring_height);
		// Remove the Top Notch (built of intersection of inner wall cylinder and cube for notch)
		intersection() {
			translate([0,0,height])
				cylinder(d=inner_diameter,h=back_ring_height);
			translate([-back_top_notch_width/2,0,height])
				cube([back_top_notch_width,diameter/2,back_top_notch_height]);
		}
		// Remove the Bottom Notch (built of intersection of inner wall cylinder and cube for notch)
		intersection() {
			translate([0,0,height])
				cylinder(d=inner_diameter,h=back_ring_height);
			translate([-back_bottom_notch_width/2,-diameter/2,(height+back_ring_height-back_bottom_notch_height)])
				cube([back_bottom_notch_width,diameter/2,back_bottom_notch_height]);
		}
		// Remove screw hole for bottom notch
		translate([0,0,(height+back_ring_height-screw_offset)])
			rotate(a=90,v=[1,0,0])
				cylinder(d=screw_hole_diameter,h=diameter);
	}

}
