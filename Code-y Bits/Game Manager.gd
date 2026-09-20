extends Node

# Quota & Shift Variables
var shift_number: int = 1
var base_quota: float = 10.0
var growth_rate: float = 1.35
var target_quota: float = 0.0
var current_progress: float = 0.0

# Overtime Mechanics
var is_in_overtime: bool = false
var overtime_seconds: float = 0.0
var multiplier_growth_per_sec: float = 0.15
var base_multiplier: float = 1.0
var total_score: float = 0.0

signal camera_shake(strength: float)
signal zoom_camera(target_zoom: Vector2, duration: float)
signal spawn_exit

# --- TUTORIAL TRACKING FLAGS ---
var has_picked_up_tomato: bool = false
var has_cut_tomato: bool = false
var has_cooked_tomato: bool = false
var has_blended_tomato: bool = false
var has_bottled_tomato: bool = false
var has_submitted_ketchup: bool = false

func _ready() -> void:
	start_new_shift()

func _process(delta: float) -> void:
	if is_in_overtime:
		overtime_seconds += delta

func start_new_shift() -> void:
	current_progress = 0.0
	is_in_overtime = false
	overtime_seconds = 0.0
	reset_tutorial_flags()
	
	target_quota = floor(base_quota * pow(growth_rate, shift_number - 1))
	print("Shift %d Started. Goal: %d" % [shift_number, target_quota])

func reset_tutorial_flags() -> void:
	has_picked_up_tomato = false
	has_cut_tomato = false
	has_cooked_tomato = false
	has_blended_tomato = false
	has_bottled_tomato = false
	has_submitted_ketchup = false

func add_progress(amount: float) -> void:
	var current_multiplier: float = get_current_multiplier()
	var earned_points: float = amount * current_multiplier
	
	current_progress += earned_points
	total_score += earned_points
	
	if not is_in_overtime and current_progress >= target_quota:
		enter_overtime()

func enter_overtime() -> void:
	spawn_exit.emit()
	is_in_overtime = true
	print("Quota Met! Overtime Started.")

func get_current_multiplier() -> float:
	if not is_in_overtime:
		return base_multiplier
	return base_multiplier + (overtime_seconds * multiplier_growth_per_sec)

func end_shift_manually() -> void:
	is_in_overtime = false
	shift_number += 1
	start_new_shift()
