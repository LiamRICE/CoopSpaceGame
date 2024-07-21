extends CanvasLayer

var player:Node

@onready var gas_list = $LeftMarginContainer/LeftContainer/GasContainer

# loading sub elements
@onready var gas_container = preload("res://user_interface/gas_container.tscn")

func _ready():
	# finding player link
	var root:Node = $/root
	var child:Node = root.get_child(0)
	player = child.get_node("Players/Player")
	print(player.get_path())
	player.connect("on_local_environment", update_environment)

func _process(delta):
	pass

func update_environment(environment: AtmosphericComposition):
	var children = gas_list.get_children()
	for gas in environment.composition:
		var is_in_children = false
		for child in children:
			if child.gas == gas:
				is_in_children = true
				child.update(gas, environment.composition[gas]["pressure"], environment.composition[gas]["temperature"])
		if not is_in_children:
			var new_node = gas_container.instantiate()
			gas_list.add_child(new_node)
			new_node.update(gas, environment.composition[gas]["pressure"], environment.composition[gas]["temperature"])
