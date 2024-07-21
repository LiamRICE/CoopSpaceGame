extends MarginContainer

@onready var gas_name_label: Label = $HBoxContainer/GasNameLabel
@onready var gas_p_label: Label = $HBoxContainer/GasPressureLabel
@onready var gas_t_label: Label = $HBoxContainer/GasTempLabel

var gas: Gasses.Gas
var p:float
var t:float

func _ready():
	pass

func _process(delta):
	pass

func _precision2float(num:float) -> String:
	var str_val:String = str(num)
	var total = str_val.split(".")
	if len(total) > 1:
		str_val = total[0] + "." + total[1].left(2)
	else:
		str_val = total[0]
	return str_val

func update(gas:Gasses.Gas, p:float, t:float):
	self.gas = gas
	self.p = p
	self.t = t
	gas_name_label.text = Gasses.Gas.keys()[gas]
	var str_p:String = _precision2float(p)
	var str_t:String = _precision2float(t)
	gas_p_label.text = str_p+"Bar"
	gas_t_label.text = str_t+"°C"
