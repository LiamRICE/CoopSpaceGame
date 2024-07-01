extends Node2D


@onready var box = $Box
const Box = preload("res://scenes/objects/static_object.tscn")


func _ready():
	for i in range(10):
		for j in range(10):
			var new_box = Box.instantiate()
			new_box.position = Vector2(100*i-500, 100*j-500)
			add_child(new_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		box.get_node("Flammable").start_fire(true)
