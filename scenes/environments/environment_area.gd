extends BaseEnvironment

class_name EnvironmentArea

var area : Area2D = null
var bodies : Array[Node2D] = []

func _ready():
	# fetch Area2D attached to the environment
	if self.get_child_count() > 0:
		var child = self.get_child(0)
		if child is Area2D:
			area = child
	area.connect("body_entered", add_body)
	
func _process(_delta):
	for body in bodies:
		apply_effect(body)

func add_body(body: Node2D):
	if body not in bodies:
		bodies.append(body)

func remove_body(body: Node2D):
	bodies.erase(body)
