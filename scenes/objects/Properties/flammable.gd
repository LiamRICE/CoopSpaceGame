class_name Flammable

extends Node

# Properties enumeration
const Properties = preload("res://scenes/objects/object_enums.gd").Properties

# Property Constants
const FIRE_DMG :float = 5
const FLAMMABILITY :float = 100
const SPREAD_DST :float = 10 # Distance spread in meters (1m => 100 px)

# BURNING STATE VARIABLES
@export var is_burning := false
@export var is_spreadable := true
@export var is_being_lit := false

# Associated nodes
@onready var effect := $Effect
@onready var fire_bar := $FireBar
var spreading_node :Flammable


func _ready():
	if is_burning:
		start_fire(true)
	elif is_being_lit:
		spread_fire()


func _physics_process(delta):
	if is_being_lit:
		if not spreading_node == null:
			if spreading_node.global_position.distance_to(self.global_position) <= SPREAD_DST * 100:
				if fire_bar.value >= fire_bar.max_value:
					start_fire()
				else:
					fire_bar.value = fire_bar.value + delta
			elif spreading_node.position.distance_to(self.position) <= SPREAD_DST * 100 and fire_bar.value > 0:
				fire_bar.value = fire_bar.value - delta
			elif fire_bar.value <= 0:
				spreading_node = null
				is_being_lit = false
				fire_bar.visible = false


func spread_fire(node:Flammable = self):
	if not is_burning:
		is_being_lit = true
		fire_bar.value = 0
		fire_bar.visible = true
		fire_bar.max_value = 100/FLAMMABILITY
		spreading_node = node


func inflict_damage(healthComponent):
	healthComponent.health -= FIRE_DMG


func start_fire(forced:bool = false):
	if forced:
		initialize_fire()
	elif not is_burning and is_being_lit:
		initialize_fire()


func initialize_fire():
	is_burning = true
	is_being_lit = false
	fire_bar.visible = false
	effect.visible = true
	if is_spreadable:
		var flammables := get_tree().get_nodes_in_group("flammables")
		for i in flammables:
			if not i == self and not i.is_burning and not i.is_being_lit:
				var distance = self.global_position.distance_to(i.global_position)
				if distance <= SPREAD_DST * 100:
					i.spread_fire(self)


func stop_fire():
	if is_burning:
		is_burning = false
		effect.visible = false
	if is_being_lit:
		is_being_lit = false
		
