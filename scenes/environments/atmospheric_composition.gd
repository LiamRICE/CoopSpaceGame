class_name AtmosphericComposition

# contains :
#	- gas
#	- pressure (atm)
#	- temp (C)
var composition: Dictionary = {}

var is_infinite = false
var total_pressure: float = 0
var total_temperature: float = 0

func _init(is_inf: bool = false):
	is_infinite = is_inf

func add_gas(gas: Gasses.Gas, pressure: float, temp: float):
	if composition.has(gas):
		var prev_pres: float = composition[gas]["pressure"]
		var prev_temp: float = composition[gas]["temperature"]
		composition[gas]["pressure"] = prev_pres + pressure
		composition[gas]["temperature"] = ((prev_temp * prev_pres) + (pressure * temp)) / (prev_pres + pressure)
	else:
		composition[gas] = {}
		composition[gas]["pressure"] = pressure
		composition[gas]["temperature"] = temp
	equalise()

func remove_gas(gas: Gasses.Gas, pressure: float):
	# check for accidental negative pressure
	if pressure < 0:
		pressure = -pressure
	# remove gas
	if composition.has(gas):
		composition[gas]["pressure"] -= pressure
		if composition[gas]["pressure"] <= 0:
			composition.erase(gas)
	# else do nothing since there was none of this gas in the first place
	equalise()

# sets all temperatures to be even
func equalise():
	var sum: float = 0
	var divider: float = 0
	for entry in composition:
		var p = composition[entry]["pressure"]
		var t = composition[entry]["temperature"]
		divider += p
		sum += t * p
	var end_temp = 0
	if divider > 0:
		end_temp = sum / divider
	for entry in composition:
		composition[entry]["temperature"] = end_temp
	total_temperature = end_temp
	total_pressure = divider

# temp per bar (positive or negative)
func add_temperature(temp: float):
	var sum: float = 0
	var divider: float = 0
	for entry in composition:
		var p = composition[entry]["pressure"]
		var t = composition[entry]["temperature"]
		divider += p
		sum += t * p
	var end_temp = 0
	if divider > 0:
		end_temp = (sum + temp) / divider
	for entry in composition:
		composition[entry]["temperature"] = end_temp
	total_temperature = end_temp

func get_pressure(gas:Gasses.Gas) -> float:
	if composition.has(gas):
		return composition[gas]["pressure"]
	else:
		return 0.0

func get_temperature(gas:Gasses.Gas) -> float:
	if composition.has(gas):
		return composition[gas]["temperature"]
	else:
		return 0.0

# WARNING : does not include temperature (positive is to add, negative is to remove)
func diff(atmosphere: AtmosphericComposition) -> AtmosphericComposition:
	var diff = AtmosphericComposition.new()
	for gas in composition:
		if atmosphere.composition.has(gas):
			diff.add_gas(gas, atmosphere.composition[gas]["pressure"] - composition[gas]["pressure"], atmosphere.composition[gas]["temperature"])
		else:
			diff.add_gas(gas, -composition[gas]["pressure"], composition[gas]["temperature"])
	for gas in atmosphere.composition:
		if not diff.composition.has(gas):
			diff.add_gas(gas, atmosphere.composition[gas]["pressure"], atmosphere.composition[gas]["temperature"])
	return diff

func temp_diff(temp: float) -> float:
	return total_temperature - temp

func print():
	print("Total Pressure :", str(total_pressure) + "Bar")
	print("Total Temperature : ", str(total_temperature) + "°C")
	print("Composition :")
	var keys = Gasses.Gas.keys()
	for gas in composition:
		print(keys[gas].capitalize() + "\t" + str(composition[gas]["pressure"]) + "Bar\t" + str(composition[gas]["temperature"]) + "°C")
