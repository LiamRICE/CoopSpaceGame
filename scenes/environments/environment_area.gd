extends BaseEnvironment

class_name EnvironmentArea

var area : Area2D = null
var bodies : Array[Node2D] = []
var composition: AtmosphericComposition = AtmosphericComposition.new()

func _ready():
	# fetch Area2D attached to the environment
	if self.get_child_count() > 0:
		var child = self.get_child(0)
		if child is Area2D:
			area = child
	area.connect("body_entered", add_body)
	area.connect("body_exited", remove_body)

func _physics_process(_delta):
	for body in bodies:
		apply_effect(body)

func add_body(body: Node2D):
	print("Body entered!")
	if body not in bodies:
		bodies.append(body)

func remove_body(body: Node2D):
	print("Body exited!")
	bodies.erase(body)

func mix(foreign_environment: EnvironmentArea):
	# mix this environment evenly with the foreign environment
	# mix = add both then divide all by two
	# then lerp from origin to mix over time dictated by opening ratio
	# plus apply force towards mixing point for wind
	pass
