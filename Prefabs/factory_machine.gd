extends Node2D
class_name factory_machine

enum machine_type {source, blender, cutter, cooking, deposit}
@export var type: machine_type

func Use(player: player_script):
	match type:
		machine_type.source:
			player._tomato_fresh += 1
		machine_type.blender:
			if player._tomato_fresh > 0:
				pass
