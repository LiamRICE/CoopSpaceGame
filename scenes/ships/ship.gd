extends Node2D

class_name Ship

@onready var COMPARTMENTS: Node2D = $Compartments

var components: Array[Node]
var environments: Array[Node] = []

func _ready():
	# detect compartments in ship
	components = $Compartments.get_children()
	for component in components:
		if "LOCAL_ENVIRONMENT" in component:
			environments.append(component.LOCAL_ENVIRONMENT)
	
	print(environments)

func _process(delta):
	pass
