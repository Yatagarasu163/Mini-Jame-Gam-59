extends Node2D
class_name factory_spawner

@export var x_size: int = 5
@export var y_size: int = 5
@export var factory_room_prefab: PackedScene
@export var x_multiplier: float = 640
@export var y_multiplier: float = 640

func _ready() -> void:
	SpawnFactory()

func _process(_delta: float) -> void:
	pass

func SpawnFactory():
	var all_rooms: Array[factory_room]
	var x_diff: int = roundi(x_size / 2)
	var y_diff: int = roundi(y_size / 2)
	for x in range(x_size):
		for y in range(y_size):
			var current_room = factory_room_prefab.instantiate()
			var new_x = x - x_diff
			var new_y = y - y_diff
			current_room.position = Vector2(new_x * x_multiplier, new_y * y_multiplier)
			all_rooms.append(current_room)
			add_child(current_room)
	for i in range(4):
		var selected_room_index = randi() % len(all_rooms)
		all_rooms[selected_room_index].generate(i)
		all_rooms.remove_at(selected_room_index)
	for room in all_rooms:
		room.clear_all()
	
