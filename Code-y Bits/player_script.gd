extends CharacterBody2D
class_name player_script


@export var _speed: float = 500.0
@export var _camera_normal_zoom: Vector2 = Vector2.ONE
@export var _camera_interact_zoom: Vector2 = Vector2.ONE
@export var _camera_zoom_speed: float = 15.0
@export var _sprite: AnimatedSprite2D
@export var _camera: Camera2D

var direction: Vector2
var using: bool

var _current_machine: factory_machine
var _tomato: Array[int] = [0, 0, 0, 0, 0]
#1 _tomato_fresh
#2 _tomato_cut
#3 _tomato_blend
#4 _tomato_cooked
#5 _tomato_bottled

func _physics_process(_delta: float) -> void:
	Movement()
	Sprite()
	Interaction()
	UseMachineState()

func Movement():
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed
	move_and_slide()
func Sprite():
	if direction != Vector2.ZERO:
		_sprite.play("Walk_Right")
	else:
		_sprite.play("Idle_Right")
	if direction.x > 0:
		_sprite.flip_h = false
	if direction.x < 0:
		_sprite.flip_h = true
func Interaction():
	if Input.is_action_just_pressed("interact") and _current_machine != null:
		_current_machine.Use(self)

func UseMachineState():
	if using:
		_camera.zoom = lerp(_camera.zoom, _camera_interact_zoom, _camera_zoom_speed * 0.01)
	else:
		_camera.zoom = lerp(_camera.zoom, _camera_normal_zoom, _camera_zoom_speed * 0.01)
func AddResource(type: int):
	_tomato[type - 1] += 1
func RemoveResource(type: int) -> bool:
	if type == 0: 
		return true
	if _tomato[type - 1] > 0:
		_tomato[type - 1] -= 1
		return true
	return false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is factory_machine:
		if _current_machine != null:
			_current_machine.InStandby(false)
		_current_machine = body
		_current_machine.InStandby(true)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body == _current_machine:
		_current_machine.InStandby(false)
		_current_machine = null
