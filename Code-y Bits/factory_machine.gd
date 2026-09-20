extends Node2D
class_name factory_machine

enum machine_type {source, blender, cutter, cooking, bottler, deposit}
@export var type: machine_type
@export var machine_sprite: Texture
@export var input_sprite: Texture
@export var output_sprite: Texture
@export var timer_duration: float = 1

@onready var machine_renderer: Sprite2D = $"Machine Sprite"
@onready var indicator: Node2D = $Indicator
@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var input_label: Label = $Input/Label
@onready var output_label: Label = $Output/Label

var use_state: bool
var time_left: float

var input_type: int
var output_type: int
var input_amt: int
var output_amt: int
var player: player_script

func _ready() -> void:
	if machine_sprite != null:
		machine_renderer.texture = machine_sprite
	match type:
		machine_type.source:
			input_type = 0
			output_type = 1
		machine_type.cutter:
			input_type = 1
			output_type = 2
		machine_type.blender:
			input_type = 2
			output_type = 3
		machine_type.cooking:
			input_type = 3
			output_type = 4
		machine_type.bottler:
			input_type = 4
			output_type = 5
		machine_type.deposit:
			input_type = 5
			output_type = 0
	#timer.wait_time = timer_duration
	progress_bar.max_value = timer_duration
	InStandby(false)

func _process(_delta: float) -> void:
	#if timer.is_stopped() and input_amt > 0:
		#timer.start()
	#progress_bar.value = timer.wait_time - timer.time_left
	
	if not use_state:
		return
	
	if time_left > 0 and input_amt > 0:
		time_left -= _delta
	if time_left <= 0 and input_amt > 0:
		time_left = timer_duration
		input_amt -= 1
		output_amt += 1
		UpdateLabels()
	progress_bar.value = timer_duration - time_left
	
	if Input.is_action_just_pressed("deposit_input") and player.RemoveResource(input_type):
		print("Player placed: " + str(player._tomato[input_type]))
		print("Holding Input: " + str(input_amt))
		input_amt += 1
		UpdateLabels()
	if Input.is_action_just_pressed("take_output") and output_amt > 0:
		print("Player got total: " + str(player._tomato[input_type]))
		player.AddResource(output_type)
		output_amt -= 1
		UpdateLabels()

func Use(_player: player_script):
	print(machine_type.find_key(type) + " on use")
	use_state = !use_state
	_player.using = use_state
	player = _player

func InStandby(state: bool):
	if state:
		print(machine_type.find_key(type) + " on standby")
		indicator.show()
	else:
		print(machine_type.find_key(type) + " disengaged")
		indicator.hide()
		use_state = false
		if player != null:
			player.using = use_state

func UpdateLabels():
	input_label.text = str(input_amt)
	output_label.text = str(output_amt)

func _on_timer_timeout() -> void:
	input_amt -= 1
	output_amt += 1
	UpdateLabels()
