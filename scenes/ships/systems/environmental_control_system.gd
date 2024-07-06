extends System

class_name EnvironmentalControlSystem

# local environment
@export var local_environment: EnvironmentArea

# atmosphere
var target_atmosphere: AtmosphericComposition = AtmosphericComposition.new()
var injection_timer: int = 30
var injection_time: int = randi_range(0, 30)
var injection_pressure = 0.01

func _ready():
	obj_name = "Environmental Control System"
	# TESTING
	target_atmosphere.add_gas(Gasses.Gas.OXYGEN, 0.2, 5)
	target_atmosphere.add_gas(Gasses.Gas.NITROGEN, 0.8, 5)

func _physics_process(delta):
	# run system twice per second
	if local_environment != null:
		injection_time -= 1
		if injection_time <= 0:
			injection_time = injection_timer
			run_system()
	else:
		print("WARNING - ENVIRONMENT NOT CONNECTED TO ENVIRONMENTAL CONTROL SYSTEM !")

func run_system():
	var diff: AtmosphericComposition = local_environment.diff(target_atmosphere)
	# get value add coeficient
	var sum = 0
	for gas in diff.composition:
		sum += diff.composition[gas]["pressure"]
	# check if gas is at limit
	if sum != 0:
		var y = injection_pressure / sum
		# set diff environment to pressure limit
		for gas in diff.composition:
			diff.composition[gas]["pressure"] = diff.composition[gas]["pressure"] * y
		# add diff to local environment
		local_environment.add(diff)
