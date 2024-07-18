extends Node


var object_list : Array[Flammable] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("flammables"):
		object_list.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_flammable(flammable:Flammable):
	object_list.append(flammable)
