extends Node2D
class_name factory_room

@export var _machines: Array[Node2D]


func generate(type: int):
	for i in range(len(_machines)):
		print("Room at " + str(position.x) + ", " + str(position.y) + " : " + str(i) + " --> " + str(type))
		if i != type:
			_machines[i].queue_free()

func clear_all():
	for machine in _machines:
		machine.queue_free()
	print("Room at " + str(position.x) + ", " + str(position.y) + " : cleared")
