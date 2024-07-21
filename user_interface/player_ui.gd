extends CanvasLayer

var player: Node

@onready var health_bar: ProgressBar = $BottomContainer/BottomMarginContainer/HealthBar

func _ready():
	# finding player link
	var root:Node = $/root
	var child:Node = root.get_child(0)
	player = child.get_node("Players/Player")
	print(player.get_path())
	player.connect("on_health_bar_value_changed", update_health_bar)

func _process(delta):
	pass

func update_health_bar(newValue:int):
	if newValue < 0:
		newValue = 0
	elif newValue > 100:
		newValue = 100
	health_bar.value = newValue
