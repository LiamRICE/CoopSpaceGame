extends BaseEnvironment

class_name EnvironmentArea

const wait_time: int = 30 # in physics tics (60/sec)

var area : Area2D = null
var bodies : Array[Node2D] = []
var composition: AtmosphericComposition = AtmosphericComposition.new()
var check_time: int = 0 # random between 0 and wait_time

func _ready():
	# fetch Area2D attached to the environment
	if self.get_child_count() > 0:
		var child = self.get_child(0)
		if child is Area2D:
			area = child
	area.connect("body_entered", add_body)
	area.connect("body_exited", remove_body)

func _physics_process(delta):
	# countdown
	check_time -= 1
	if check_time <= 0:
		check_time = wait_time
	# run check
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
