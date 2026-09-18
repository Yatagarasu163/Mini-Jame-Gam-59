extends Node2D
class_name factory_spawner

@export var x_size: int = 5
@export var y_size: int = 5
@export var factory_room: PackedScene
@export var x_multiplier: float = 640
@export var y_multiplier: float = 640

func _ready() -> void:
	SpawnFactory()

func _process(_delta: float) -> void:
	pass

func SpawnFactory():
	var x_diff: int = x_size / 2
	var y_diff: int = y_size / 2
	for x in range(x_size):
		for y in range(y_size):
			var current_room = factory_room.instantiate()
			var new_x = x - x_diff
			var new_y = y - y_diff
			current_room.position = Vector2(new_x * x_multiplier, new_y * y_multiplier)
			add_child(current_room)
