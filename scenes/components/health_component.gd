class_name HealthComponent

extends Node


# Properties
@export var maxHealth :float
@export var health :float:
	set(value):
		health = clampf(value, 0, maxHealth)
	get:
		return roundi(health)


# Called when the node enters the scene tree for the first time.
func take_damage(dmg):
	health -= dmg
	if health <= 0:
		health = 0
		print(str(get_parent()) + " has been destroyed")
		get_parent().queue_free()
