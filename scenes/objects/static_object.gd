extends Node2D

const Properties = preload("res://scenes/objects/object_enums.gd").Properties

var properties :Array[Node]
@onready var effect_area :Area2D = $Effect_area

var monitored_property :Properties = Properties.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_properties()
	
	for i in properties:
		if not i == null:
			i.property_event.connect(_on_property_event)
		else:
			printerr("An empty property in the array in object " + str(self))
	
	effect_area.body_entered.connect(_on_body_entered)


func _load_properties():
	if self.has_node("Flammable"):
		properties.append($Flammable)
	if self.has_node("Conductive"):
		properties.append($Conductive)
	if self.has_node("Destructible"):
		properties.append($Destructible)
	if self.has_node("Explosive"):
		properties.append($Explosive)
	if self.has_node("Acidic"):
		properties.append($Acidic)
	if self.has_node("Wet"):
		properties.append($Wet)


# Fires when the fire spreads. Activates the area of effect.
func _on_property_event(origin :Properties):
	print(str(origin) + " means a flammable thing happened.")
	if monitored_property == origin:
		monitored_property = Properties.NONE
		effect_area.monitoring = false
	else:
		monitored_property = origin
		effect_area.monitoring = true


func _on_body_entered(body :Node2D):
	print("Body entered !")
	if body.has_node("Flammable"):
		body.get_node("Flammable").start_fire()
		print("New fire started !")
	elif body.has_node("Explosive"):
		body.get_node("Explosive").start_explosion()
		print("New explosion started !")
	
	
