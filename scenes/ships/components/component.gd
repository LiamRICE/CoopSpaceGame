extends Area2D

class_name Component

@onready var SYSTEM_LIST: Node2D = $Systems
@onready var ENVIRONMENT: Node2D = null
@export var SYSTEMS: Array[Node] = []

func _ready():
	# detect systems in component
	SYSTEMS = SYSTEM_LIST.get_children()
	if $Environment.get_child_count() > 0:
		ENVIRONMENT = $Environment.get_child(0)

func _process(delta):
	pass
