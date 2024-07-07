extends CharacterBody2D

class_name Character

# movment constants
const WALK: float = 6000.0
const RUN: float = 24000.0

# movment variables
var speed: float = WALK
var direction: Vector2 = Vector2.ZERO
var sprint: bool = false

# environment variables
var is_in_environment_zone:bool = false
# breathing limits
var breathing_gas:Gasses.Gas
var exhaling_gas:Gasses.Gas
var breathing_temp: float = 36
var breathing_quantity: float = 0.0001
var min_pressure:float = 0.12
var max_pressure:float = 2
var hold_breath_limit:float = 120
var breath_reduce:float = 1
var current_breath:float = hold_breath_limit
# temperature limits
var min_temp:float = 10
var max_temp:float = 46
# poison gas limits
var poison_gas:Dictionary = {}
var max_poison_gain:float = 100
var current_poison_gain:float = 0
var is_poisoned:bool = false
var base_poison_processing: float = 0.001
var current_poison_processing:float = base_poison_processing

# life variables
var hp:float = 100

func _init():
	# human
	breathing_gas = Gasses.Gas.OXYGEN
	exhaling_gas = Gasses.Gas.CARBON_DIOXIDE
	poison_gas[Gasses.Gas.CARBON_DIOXIDE] = 0.02
	poison_gas[Gasses.Gas.HYDROGEN] = 0.05

# generic function for environment survival
func apply_environment(environment: AtmosphericComposition) -> Dictionary:
	var is_breathing = false
	# get relative pressure and temp of breathing gas
	var p = environment.get_pressure(breathing_gas)
	var t = environment.total_temperature
	var pt = environment.total_pressure
	# ========== PRESSURE ========== #
	if p < min_pressure:
		print("Pressure Low")
		current_breath -= breath_reduce # can't breathe
		if current_breath <= 0:
			suffocating() # suffocating
	else:
		# can breathe - regain breath if necessary
		if current_breath < hold_breath_limit:
			current_breath += 5*breath_reduce
		if current_breath > hold_breath_limit:
			current_breath = hold_breath_limit
		# TODO - remove breathable gas and add expulsed poison gas
	if p > max_pressure:
		print("Pressure High")
		hp -= 4 # being crushed
	# ========== TEMPERATURE ========== #
	if t < min_temp:
		print("Freezing")
		hp -= 0.1 # freezing
	elif t > max_temp:
		print("Overheating")
		hp -= 0.05 # too hot
	# ========== POISONS ========== #
	var any_poison: bool = false
	for gas in poison_gas:
		var poisoned = environment.get_pressure(breathing_gas) - poison_gas[gas]
		if poisoned > 0:
			any_poison = true
			current_poison_gain += poisoned
	if any_poison:
		is_poisoned = true
	else:
		is_poisoned = false
		current_poison_gain -= current_poison_processing
	if current_poison_gain > max_poison_gain:
		suffocating(current_poison_gain/max_poison_gain)
	# return breathing data
	if is_breathing:
		var dict = {}
		dict[breathing_gas] = {}
		dict[breathing_gas]["pressure"] = breathing_quantity
		dict[breathing_gas]["temperature"] = breathing_temp
		dict[exhaling_gas] = {}
		dict[exhaling_gas]["pressure"] = breathing_quantity
		dict[exhaling_gas]["temperature"] = breathing_temp
		return dict
	else:
		return {}

func suffocating(factor:float=1):
	hp -= 2

func set_environment(is_in_environment: bool):
	is_in_environment_zone = is_in_environment
