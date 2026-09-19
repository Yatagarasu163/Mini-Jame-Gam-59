extends Node

@export var exfil_node: Node2D
# Quota Parameters
var shift_number: int = 1
var base_quota: float = 100.0
var growth_rate: float = 1.35  # Increases quota by 35% each shift
var target_quota: float = 0.0
var current_progress: float = 0.0

# Overtime Mechanics
var is_in_overtime: bool = false
var overtime_seconds: float = 0.0
var multiplier_growth_per_sec: float = 0.15  # Increases multiplier by +0.15x per second
var base_multiplier: float = 1.0

# Total score saved for meta-progression or shop upgrades
var total_score: float = 0.0

func _ready() -> void:
	start_new_shift()

func _process(delta: float) -> void:
	if is_in_overtime:
		overtime_seconds += delta
		# Escalating hazard or intensity logic can be triggered here based on overtime_seconds

func start_new_shift() -> void:
	current_progress = 0.0
	# Calculate dynamic quota exponentially based on shift number
	target_quota = floor(base_quota * pow(growth_rate, shift_number - 1))
	print("Shift %d Started. Goal: %d" % [shift_number, target_quota])
	# Hide the Exfil node at the start of every new shift
	if exfil_node:
		exfil_node.visible = false
	#start to procedurally generate the rooms

func add_progress(amount: float) -> void:
	var current_multiplier: float = get_current_multiplier()
	var earned_points: float = amount * current_multiplier
	
	current_progress += earned_points
	total_score += earned_points
	#everytime the progress goes up the size of the tomato gets bigger and if limit hit increase speed
	# Check if quota is hit to trigger Overtime state
	if not is_in_overtime and current_progress >= target_quota:
		enter_overtime()

func enter_overtime() -> void:
	is_in_overtime = true
	print("Quota met! Head to the exfil room to clock out OR keep working for more points.")
	# Reveal the exfil room/door and activate its interaction area
	#change the state of the tomato
	if exfil_node:
		exfil_node.visible = true
	#if player clock out in exfil room go to end_shift_manually()

func get_current_multiplier() -> float:
	if not is_in_overtime:
		return base_multiplier
	# Formula: Multiplier scales exponentially or linearly with time spent in overtime
	return base_multiplier + (overtime_seconds * multiplier_growth_per_sec)

func end_shift_manually() -> void:
	# Player clocks out voluntarily to claim all earned points
	is_in_overtime = false
	print("Shift Ended! Total Score Earned: %d" % total_score)
	
func lose() -> void:
	#if player gets hit by tomato
	print("You got lost in the sauce.")
	#ui pop up to retry or back to main menu
