extends System

class_name ClimateControlSystem

# local environment
@export var local_environment: EnvironmentArea

var injection_timer: int = 30
var injection_time: int = randi_range(0, 30)
var temp_per_pressure: float

# temperature control variables
var target_temperature: float = 21
var temperature_variance: float = 1

func _ready():
	obj_name = "Environmental Control System"
	size = 1
	temp_per_pressure = 0.1 * size

func _process(delta):
	# run system twice per second
	if local_environment != null:
		injection_time -= 1
		if injection_time <= 0:
			injection_time = injection_timer
			run_system()
	else:
		print("WARNING - ENVIRONMENT NOT CONNECTED TO ENVIRONMENTAL CONTROL SYSTEM !")

func run_system():
	var current_temp = local_environment.get_temp()
	if current_temp > target_temperature - 1:
		local_environment.add_temp(-temp_per_pressure)
	elif current_temp < target_temperature + 1:
		local_environment.add_temp(temp_per_pressure)
