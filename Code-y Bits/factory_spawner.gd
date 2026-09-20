extends Node2D
class_name factory_spawner

@export var x_size: int = 5
@export var y_size: int = 5
@export var factory_room_prefab: PackedScene
@export var x_multiplier: float = 640
@export var y_multiplier: float = 640

@onready var world_border_x_neg: StaticBody2D = $"World Border Left"
@onready var world_border_x_pos: StaticBody2D = $"World Border Right"
@onready var world_border_y_neg: StaticBody2D = $"World Border Top"
@onready var world_border_y_pos: StaticBody2D = $"World Border Bottom"

func _ready() -> void:
	SpawnFactory()

func _process(_delta: float) -> void:
	pass

func SpawnFactory():
	var rooms: Array[factory_room]
	var x_diff: int = roundi(x_size / 2)
	var y_diff: int = roundi(y_size / 2)
	world_border_x_neg.position.x = -(x_diff * x_multiplier) - (x_multiplier / 2)
	world_border_x_pos.position.x = (x_diff * x_multiplier) + (x_multiplier / 2)
	world_border_y_neg.position.y = -(y_diff * y_multiplier) - (y_multiplier / 2)
	world_border_y_pos.position.y = (y_diff * y_multiplier) + (y_multiplier / 2)
	for x in range(x_size):
		for y in range(y_size):
			var current_room = factory_room_prefab.instantiate()
			rooms.append(current_room)
			var new_x = x - x_diff
			var new_y = y - y_diff
			current_room.position = Vector2(new_x * x_multiplier, new_y * y_multiplier)
			add_child(current_room)
	# generate one copy of all the necessary rooms
	for i in range(7):
		var selected_room = randi() % len(rooms)
		rooms[selected_room].generate(i - 1)
		rooms.remove_at(selected_room)
	print("---- Bonus Rooms: ----")
	for i in range(len(rooms)):
		if (randi() % 5 == 0):
			rooms[i].generate(randi() % 4)
		else:
			rooms[i].generate(-1)
