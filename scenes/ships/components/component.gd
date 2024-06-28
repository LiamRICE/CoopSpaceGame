extends Area2D

class_name Component

@onready var SYSTEM_LIST: Node2D = $Systems
@onready var LOCAL_ENVIRONMENT: Node2D = null
@export var systems: Array[Node2D]

func _ready():
	# detect systems in component
	var systems = SYSTEM_LIST.get_children()
	if $Environment.get_child_count() > 0:
		LOCAL_ENVIRONMENT = $Environment.get_child(0)

func _process(delta):
	pass
