extends CharacterBody2D
class_name enemy_script

@export var _speed: float

var _player_target: Node2D

func _ready() -> void:
	# set player target to find the player object
	pass

func _physics_process(delta: float) -> void:
	
	move_and_slide()
