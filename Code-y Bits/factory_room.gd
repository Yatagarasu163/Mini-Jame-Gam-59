extends Node2D
class_name factory_room

@export var _machines: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for machine in _machines:
		machine.visible = false

func generate(type: int):
	_machines[type].visible = true
