shader_type canvas_item;


void vertex() {
	if(VERTEX.y < 0.0){
		VERTEX.x = VERTEX.x + (0.8 * sin(TIME * 1.5) + 0.5 * sin(TIME * 4.2) + 0.1 * sin(TIME * 10.4) + 0.05 * sin(TIME * 15.7)) * 200.0;
		VERTEX.y = VERTEX.y + 0.8 + (0.8 * sin(TIME * 1.2) + 0.5 * sin(TIME * 5.6) + 0.1 * sin(TIME * 9.4) + 0.05 * sin(TIME * 16.9)) * 100.0;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
