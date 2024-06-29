extends Node2D

class_name BaseEnvironment

const environment_name: String = "Void"
var pressure: float = 0.0 # pressure in atm


# generic application function for all environments
func apply_effect(body: Node2D):
	pass
