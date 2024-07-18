extends Node2D

class_name System

var obj_name: String = ""
var size: float = 0

func _ready():
	obj_name = "Climate Control System"
	size = 1

func _process(_delta):
	pass

# generic base function
func interact():
	pass

# generic base function
func run_system():
	pass
