extends CharacterBody2D

@export var _speed: float = 500.0

@onready var _anim: AnimatedSprite2D = $AnimatedSprite2D

var _tomato_fresh: int = 0
var _tomato_cut: int = 0
var _tomato_cooked: int = 0
var _tomato_blended: int = 0
var _tomato_bottled: int = 0

var _max_tomatoes: int = 5

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed
	
	if direction != Vector2.ZERO:
		_anim.play("Walk")
	else:
		_anim.play("Idle")
	
	move_and_slide()
	
func can_collect_fresh_tomato():
	return _tomato_fresh < _max_tomatoes
	
func enough_cut_tomatoes():
	return _tomato_cut >= 1

func enough_fresh_tomatoes():
	return _tomato_fresh >= _max_tomatoes

func enough_cooked_tomatoes():
	return _tomato_cooked >= 1

func enough_blended_tomatoes():
	return _tomato_blended >= 1

func enough_bottled_tomatoes():
	return _tomato_bottled >= 1

func add_fresh_tomato():
	if _tomato_fresh < _max_tomatoes:
		_tomato_fresh = _max_tomatoes
		print("Fresh Tomatoes: ", _tomato_fresh, "/", _max_tomatoes)
	
func finish_cutting():
	_tomato_fresh -= 5
	
	print("Fresh Tomatoes: ", _tomato_fresh)
		
func add_cut_tomato():
	_tomato_cut += 1
	print("Cut Tomatoes: ", _tomato_cut)
	
func finish_cooking():
	_tomato_cut -= 1
	print("Cut Tomatoes: ", _tomato_cut)

func add_cooked_tomato():
	_tomato_cooked += 1
	print("Cooked Tomatoes: ", _tomato_cooked)

func finish_blending():
	_tomato_cooked -= 1
	print("Cooked Tomatoes: ", _tomato_cooked)

func add_blended_tomato():
	_tomato_blended += 1
	print("Blended Tomatoes: ", _tomato_blended)


func finish_bottling():
	_tomato_blended -= 1
	print("Blended Tomatoes: ", _tomato_blended)

func add_bottled_tomato():
	_tomato_bottled += 1
	print("Bottled Tomatoes: ", _tomato_bottled)
	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	print(body.name) 
