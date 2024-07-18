extends Node2D

class_name BaseEnvironment

const environment_name: String = "Void"

var composition: AtmosphericComposition

func _ready():
	composition = AtmosphericComposition.new(true)

func add(foreign_environment: AtmosphericComposition):
	for gas in foreign_environment.composition:
		if foreign_environment.composition[gas]["pressure"] > 0:
			print("Add Gas :", Gasses.Gas.keys()[gas], " = ", foreign_environment.composition[gas]["pressure"])
			composition.add_gas(gas, foreign_environment.composition[gas]["pressure"], foreign_environment.composition[gas]["temperature"])
		else:
			print("Remove Gas :", Gasses.Gas.keys()[gas], " = ", foreign_environment.composition[gas]["pressure"])
			composition.remove_gas(gas, foreign_environment.composition[gas]["pressure"])

func diff(atmosphere: AtmosphericComposition) -> AtmosphericComposition:
	return composition.diff(atmosphere)

func add_temp(temp_per_bar: float):
	composition.add_temperature(temp_per_bar)

func get_temp() -> float:
	return composition.total_temperature

# generic application function for all environments
func apply_effect(body: Node2D):
	if "apply_environment" in body:
		var outgas = AtmosphericComposition.new()
		outgas.composition = body.apply_environment(composition)
		for gas in composition.composition:
			add(outgas)
