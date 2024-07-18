extends Node2D


@onready var box = $Box
@onready var animation_player = $AnimationPlayer
var num := 0.0

const Box = preload("res://scenes/objects/static_object.tscn")


func _ready():
	for i in range(10):
		for j in range(10):
			var new_box = Box.instantiate()
			new_box.position = Vector2(128*i-500, 128*j-500)
			add_child(new_box)
	
	
	DialogueManager.show_dialogue(null, {"name":"Steve"})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		box.get_node("Flammable").start_fire(true)
		animation_player.play("move_right")
	if delta > num:
		num = delta
		print(str(1/delta) + " FPS")
