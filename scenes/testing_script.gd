extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var box = $Box
	
	if Input.is_action_just_pressed("ui_accept"):
		box.get_node("Flammable").start_fire()
