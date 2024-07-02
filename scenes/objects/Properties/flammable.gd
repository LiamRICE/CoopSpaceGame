class_name Flammable

extends Node

# Properties enumeration
const Properties = preload("res://scenes/objects/object_enums.gd").Properties

# Property Constants
const FIRE_DMG :float = 5
const FLAMMABILITY :float = 100
const SPREAD_DST :float = 3 # Distance spread in meters (1m => 100 px)

# BURNING STATE VARIABLES
@export var is_burning := false
@export var is_spreadable := true
@export var is_being_lit := false

# Associated nodes
@onready var effect := $Effect
@onready var fire_bar := $FireBar
var spreading_nodes :Array[Flammable] = []

# control variables
var spread_counter :int = 0


func _ready():
	if is_burning:
		start_fire(true)
	elif is_being_lit:
		spread_fire()


func _physics_process(delta):
	# List the nodes no longer in range and remove them
	var nodes_to_erase :Array[Flammable] = []
	spread_counter += 1
	
	# Check if the was being set on fire in the previous frame
	if is_being_lit:
		# Initialize variables for the spreading
		var spread := false # Assume that no nodes are in range
		var i := 0 # Start at index 0 of the spreading nodes list
		var max := spreading_nodes.size() # Get the length of the spreading nodes array
		
		# If no node in range has been previously detected, check if next node is in range (and check that not getting index out-of-range)
		while not spread and i < max:
			var dst = spreading_nodes[i].global_position.distance_to(self.global_position) # Check range to current node
			if dst <= SPREAD_DST * 100: # if a source is in range, no need to check if other sources are in range
				spread = true # The node has been spread to
				if fire_bar.value >= fire_bar.max_value: # If the loading bar has reached it's max value, start the fire and remove all spreading nodes
					start_fire()
					spreading_nodes = []
				else: # Otherwise, the value hasn't reached the max, so add the delta to the value
					fire_bar.value += delta
			else: # If the node is no longer in range
				nodes_to_erase.append(spreading_nodes[i]) # Add that node to the list of nodes to no longer check
			i += 1 # Increment the index
		if not spread: # If no spreading has occurred, decrement the progress bar
			fire_bar.value -= delta # decrease the progress bar
			if fire_bar.value <= 0: # If the progress bar is below or at zero
				spreading_nodes = [] # Remove all spreading nodes (no nodes in range)
				is_being_lit = false # The node is no longer actively being lit
				fire_bar.visible = false # The fire bar can be hidden since no spreading is occuring
	
	# Erase nodes that are out of range
	for i in nodes_to_erase:
		spreading_nodes.erase(i)
	
	# If the object can spread fire and is burning (the spread_counter makes this function execute at 4Hz)
	if is_spreadable and is_burning and spread_counter >= 15:
		spread_counter = 0 # Reset the spread_counter
		var flammables := get_tree().get_nodes_in_group("flammables") # Get all of the flammable objects in the scene
		for i in flammables:
			if not i == self and not i.is_burning: # If the node being checked is on fire and is not itself
				var distance = self.global_position.distance_to(i.global_position) # Calculate the distance to that node
				if distance <= SPREAD_DST * 100:
					i.spread_fire(self) # If it's in the radius, spread fire to it


func spread_fire(node:Flammable = self):
	if not is_burning and not is_being_lit:
		is_being_lit = true
		fire_bar.value = 0
		fire_bar.visible = true
		fire_bar.max_value = 100/FLAMMABILITY
		spreading_nodes.append(node)
	elif not is_burning and is_being_lit:
		spreading_nodes.append(node)


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
			if not i == self and not i.is_burning:
				var distance = self.global_position.distance_to(i.global_position)
				if distance <= SPREAD_DST * 100:
					i.spread_fire(self)


func stop_fire():
	if is_burning:
		is_burning = false
		effect.visible = false
	if is_being_lit:
		is_being_lit = false
		
