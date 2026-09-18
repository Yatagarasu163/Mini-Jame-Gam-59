extends Node2D
class_name factory_room

@export var room_station: Array[Node2D]

func _ready() -> void:
	for i in range(len(room_station)):
		room_station[i].visible = false

func generate(room_type: int):
	if room_type == -1:
		for i in range(len(room_station)):
			room_station[i].queue_free()
		return
	
	for i in range(len(room_station)):
		if room_type == i:
			print("Room (" + str(position.x / 640) + ", " + str(position.y / 640) + ") Generated Room Type: " + str(room_type))
			room_station[room_type].visible = true
		else:
			room_station[i].queue_free()
