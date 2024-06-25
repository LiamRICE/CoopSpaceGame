class_name Flammable

extends Node

# Properties enumeration
const Properties = preload("res://scenes/objects/object_enums.gd").Properties

# Property Constants
const SPREADING_SPEED :float = 1
const FIRE_DMG :float = 5

# BURNING STATE VARIABLES
@export var is_burning := false
@export var is_spreadable := true

# Associated nodes
@onready var timer := $Timer

# Signals
signal property_event(property :Properties)


func _ready():
	if is_burning and is_spreadable:
		start_fire()


# Debug _process function
func _process(delta):
	# DEBUG
	if Input.is_action_just_pressed("ui_accept"):
		start_fire()


# Spreads the fire when the timer fires
func _spread():
	property_event.emit(Properties.FLAMMABLE)


func start_fire():
	is_burning = true
	if is_spreadable:
		timer.start(SPREADING_SPEED)


func stop_fire():
	is_burning = false
	timer.stop()
