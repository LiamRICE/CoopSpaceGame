extends Node2D

class_name BaseEnvironment

const environment_name: String = "Void"

var composition: AtmosphericComposition

func _ready():
	composition = AtmosphericComposition.new(true)

# generic application function for all environments
func apply_effect(body: Node2D):
	if "apply_environment" in body:
		body.apply_environment(composition)
