extends CharacterBody2D

# movment constants
const WALK: float = 6000.0
const RUN: float = 24000.0

# movment variables
var speed: float = WALK
var direction: Vector2 = Vector2.ZERO
var sprint: bool = false

func _process(_delta):
	# get input for directional control
	direction = Input.get_vector("left", "right", "up", "down")
	sprint = Input.is_action_pressed("sprint")

func _physics_process(delta):
	# check if sprint
	if sprint:
		speed = RUN
	else:
		speed = WALK
	# calculate movment from commands in process
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed * delta
		print(direction, "*", speed, "*", delta)
		print(velocity)
	else:
		if direction.x == 0:
			velocity.x = move_toward(velocity.x, 0, speed)
		if direction.y == 0:
			velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
