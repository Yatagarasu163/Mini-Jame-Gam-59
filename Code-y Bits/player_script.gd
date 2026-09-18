extends CharacterBody2D

@export var _speed: float = 500.0
@export var _sprite: AnimatedSprite2D

var _tomato_fresh: int = 0
var _tomato_cut: int = 0
var _tomato_cooked: int = 0
var _tomato_bottled: int = 0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed
	
	if direction != Vector2.ZERO:
		_sprite.play("Walk_Right")
	else:
		_sprite.play("Idle_Right")
	if direction.x > 0:
		_sprite.flip_h = false
	if direction.x < 0:
		_sprite.flip_h = true
	
	move_and_slide()
