extends CharacterBody2D

@export var _speed: float = 500.0

var _tomato_fresh: int = 0
var _tomato_cut: int = 0
var _tomato_cooked: int = 0
var _tomato_bottled: int = 0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed
	move_and_slide()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	print(body.name) 
