extends Node2D

const Properties = preload("res://scenes/objects/object_enums.gd").Properties

# Child nodes (initialised at _ready() )
var properties :Array[Node]
@onready var effect_area :Area2D = $Effect_area

var active_properties :Array[Properties] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_properties()
	
	for i in properties:
		if not i == null:
			i.property_event.connect(_on_property_event)
			i.property_event_end.connect(_on_property_event_end)
		else:
			printerr("An empty property in the array in object " + str(self))


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
	
	var bodies := effect_area.get_overlapping_bodies()
	bodies.erase($Collision)
	for body in bodies:
		if body.get_parent().has_node("Flammable"):
			print(body)
			body.get_parent().get_node("Flammable").start_fire()
	
	effect_area.monitoring = true
	active_properties.append(origin)


func _on_property_event_end(origin :Properties):
	print(str(origin) + " means a flammable thing stopped happening.")
	active_properties.erase(origin)
	if active_properties.size() == 0:
		effect_area.monitoring = false
	
	
func _physics_process(delta):
	if not active_properties.size() == 0:
		print("Activate properties !!!")
		print(effect_area.has_overlapping_bodies())
		active_properties.erase(Properties.FLAMMABLE)
