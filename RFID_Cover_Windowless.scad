//////////////////
//Parameters
//////////////////
$fn = 180;
window_depth = 1.6;
window_diameter = 25;
window_lip_depth = 1;
window_lip_width = 3;
wall_thickness = 4;
cover_diameter = 70;
cover_height = 10;
board_width = 41;
board_height = 43.4;
board_thickness = 4;
board_x_shift = 0;
board_y_shift = 0;
led_diameter = 5.0;
circle_kerf = 0.3;
back_ring_height = 10;
back_ring_width = 10;
back_top_notch_width = 15;
back_top_notch_height = 4;
back_bottom_notch_width = 12;
back_bottom_notch_height = 10;
screw_hole_diameter = 3;
screw_offset = 5;
base_hole_diameter = 20;
base_kerf = 2.0;
mount_hole_diameter = 4.5;
nut_hole_length = 6.7;
nut_hole_width = 2.;
buzzer_height = 3;
buzzer_diameter = 13.5;
buzzer_x_offset = 25;
buzzer_y_offset = 0;
buzzer_z_offset = 11;

///////////////////
// renders
///////////////////

translate([0,0,cover_height+back_ring_height]) rotate(a=180,v=[0,1,0]) 
	base_plate(cover_diameter);
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
		// Main body
		cylinder(d=diameter,h=height);
		// Create outside walls by subtracting a cylinder
		translate([0,0,(front_height+board_thickness)]) 
			cylinder(d=inner_diameter,h=inner_height+.1);
		// Remove material to create window lip
		//translate([0,0,window_depth])
		//	cylinder(d=(window_diameter+(window_lip_width*2)+circle_kerf),h=window_lip_depth+.1);
		// Remove matrial to create window opening
		//translate([0,0,0])
		//	cylinder(d=(window_diameter+circle_kerf),h=window_depth+.1);
		// Create opening for RFID board to sit inside of.
		translate([-(board_x_shift+board_width/2),-(board_y_shift+board_height/2),front_height])
			cube([board_width,board_height,board_thickness]);
		// Create a hole for LED
		translate([0,((inner_diameter/4)+(board_height/4)),0])
			cylinder(d=(led_diameter+circle_kerf),h=(front_height+board_thickness+.1));
		// Remove buzzer cavity
		//translate([buzzer_x_offset,buzzer_y_offset,buzzer_z_offset])
		//	rotate(a=90,v=[0,1,0])
		//		cylinder(d=buzzer_diameter,h=buzzer_height);
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

module base_plate(diameter) {
   inner_diameter = (diameter-(2*wall_thickness)-base_kerf);
	inner_back_diameter = (diameter-(back_ring_width*2))-base_kerf;
	inner_base_diameter = inner_back_diameter-(2*wall_thickness);
	nut_hole_offset = screw_offset-3.8;
	difference() {
		cylinder(d=inner_back_diameter,h=back_ring_height);
		cylinder(d=base_hole_diameter,h=back_ring_height);
		translate ([0,0,wall_thickness]) cylinder(d=inner_base_diameter,h=back_ring_height);
		for(r=[0:120:360]) {
			rotate(a=r,v=[0,0,1]) translate ([0,(inner_base_diameter/4)+(base_hole_diameter/4),0]) cylinder(h=back_ring_height,d=mount_hole_diameter);
		}
	}
	//  Top Notch (built of intersection of inner wall cylinder and cube for notch)
	intersection() {
		translate([0,0,0])
			cylinder(d=inner_diameter,h=back_ring_height);
		translate([-((back_top_notch_width/2)-base_kerf),(inner_back_diameter/2)-wall_thickness,back_ring_height-back_top_notch_height])
			cube([back_top_notch_width-(base_kerf*2),(diameter/2)-(base_hole_diameter/2),back_top_notch_height]);
	}
	// Bottom Notch (built of intersection of inner wall cylinder and cube for notch)
	difference() {
		intersection() {
			translate([0,0,height])
				cylinder(d=inner_diameter,h=back_ring_height);
			translate([-((back_bottom_notch_width/2)-circle_kerf),-inner_diameter/2,(height+back_ring_height-back_bottom_notch_height)])
				cube([back_bottom_notch_width-(circle_kerf*2),(inner_diameter/2)-((inner_back_diameter/2)-wall_thickness),back_bottom_notch_height]);
		}
		// Remove screw hole for bottom notch
		translate([0,0,(screw_offset)])
			rotate(a=90,v=[1,0,0])
				cylinder(d=screw_hole_diameter,h=diameter);

		translate([-nut_hole_length/2,-((inner_diameter/4)+(inner_back_diameter/4)),nut_hole_offset])
			cube([nut_hole_length,nut_hole_width,back_ring_height-nut_hole_offset]);
	}
}
