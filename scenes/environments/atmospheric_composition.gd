class_name AtmosphericComposition

enum Gasses {
	OXYGEN,
	NITROGEN,
	CARBON_DIOXIDE,
	HELIUM,
	HYDROGEN
}

const GAS_NAMES: Array[String] = [
	"Oxygen",
	"Nitrogen",
	"Carbon Dioxide",
	"Helium",
	"Hydrogen"
]

var composition: Dictionary = {}

func _init():
	pass

func add_gas(gas: Gasses, quantity: float):
	if composition.has(gas):
		composition[gas] += quantity
	else:
		composition[gas] = quantity

func remove_gas(gas: Gasses, quantity: float):
	if composition.has(gas):
		composition[gas] -= quantity
		if quantity <= 0:
			composition.erase(gas)
	# else do nothing since there was none of this gas in the first place
