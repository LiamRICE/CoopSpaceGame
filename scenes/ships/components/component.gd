extends Area2D

class_name Component

@onready var SYSTEM_LIST: Node2D = $Systems
@export var systems: Array[Node2D]

func _ready():
	# detect systems in component
	var systems = SYSTEM_LIST.get_children()

func _process(delta):
	pass
