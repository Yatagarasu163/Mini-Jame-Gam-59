extends CharacterBody2D

@export var _speed: float

var _tomato_fresh: int
var _tomato_cut: int
var _tomato_cooked: int
var _tomato_bottled: int

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed
	move_and_slide()
