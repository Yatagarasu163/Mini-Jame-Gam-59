extends Control

# UI References
@export var label_title: Label
@export var label_description: Label

# Tutorial State
var current_step_index: int = 0
var is_tutorial_active: bool = false
var step_completed: bool = false

# Structure defining each step's title, description, and completion check
class TutorialStep:
	var step_number: String
	var description: String
	var check_condition: Callable

	func _init(p_number: String, p_description: String, p_condition: Callable) -> void:
		step_number = p_number
		description = p_description
		check_condition = p_condition

var steps: Array[TutorialStep] = []

func _ready() -> void:
	if GameManager.shift_number == 1:
		setup_tutorial_steps()
		start_tutorial()
	else:
		show_quota_only()

func _process(_delta: float) -> void:
	# Continuously refresh UI to reflect dynamic progress/quota numbers
	if not is_tutorial_active:
		show_quota_only()
		return

	if current_step_index >= steps.size() or step_completed:
		return

	var current_step: TutorialStep = steps[current_step_index]
	
	if current_step.check_condition.call():
		complete_current_step()
	else:
		update_ui()

# --- DAY 2+ QUOTA DISPLAY ---

func show_quota_only() -> void:
	is_tutorial_active = false
	visible = true
	
	var current: int = int(GameManager.current_progress)
	var target: int = int(GameManager.target_quota)
	
	if label_title:
		label_title.text = "Shift %d Goal" % GameManager.shift_number
	if label_description:
		if GameManager.is_in_overtime:
			label_description.text = "Quota Met! Current Points: %d" % current
		else:
			label_description.text = "Quota: %d / %d" % [current, target]

# --- DAY 1 TUTORIAL SYSTEM ---

func setup_tutorial_steps() -> void:
	steps = [
		TutorialStep.new(
			"Step 1:",
			"Grab a tomato from the crates",
			func() -> bool: return GameManager.has_picked_up_tomato
		),
		TutorialStep.new(
			"Step 2:",
			"Deliver the tomatoes and cut them at cutting station",
			func() -> bool: return GameManager.has_cut_tomato
		),
		TutorialStep.new(
			"Step 3:",
			"Bring the cut tomatoes to be cooked at the cooking station",
			func() -> bool: return GameManager.has_cooked_tomato
		),
		TutorialStep.new(
			"Step 4:",
			"Bring the cooked tomatoes to the blender",
			func() -> bool: return GameManager.has_blended_tomato
		),
		TutorialStep.new(
			"Step 5:",
			"Take the blended tomatoes to the bottling station",
			func() -> bool: return GameManager.has_bottled_tomato
		),
		TutorialStep.new(
			"Step 6:",
			"Take the ketchup bottle to submit",
			func() -> bool: return GameManager.has_submitted_ketchup
		),
		TutorialStep.new(
			"Step 7:",
			"Reach target quota", # Dynamic text formatting handled in update_ui()
			func() -> bool: return GameManager.is_in_overtime
		),
		TutorialStep.new(
			"Step 8:",
			"Head to the exfil room to clock out OR work overtime for more points",
			func() -> bool: return false
		)
	]

func start_tutorial() -> void:
	current_step_index = 0
	is_tutorial_active = true
	step_completed = false
	visible = true
	update_ui()

func complete_current_step() -> void:
	step_completed = true
	update_ui()
	
	await get_tree().create_timer(0.6).timeout
	
	current_step_index += 1
	step_completed = false
	
	if current_step_index < steps.size():
		update_ui()
	else:
		complete_tutorial()

func update_ui() -> void:
	var step: TutorialStep = steps[current_step_index]
	var checkbox_symbol: String = "[x]" if step_completed else "[ ]"
	
	var current: int = int(GameManager.current_progress)
	var target: int = int(GameManager.target_quota)
	
	if label_title:
		label_title.text = step.step_number
	
	if label_description:
		# Step 7 dynamically displays live progress vs target
		if current_step_index == 6:
			step.description = "Reach target quota (%d / %d)" % [current, target]
		
		label_description.text = "%s %s" % [checkbox_symbol, step.description]

func complete_tutorial() -> void:
	is_tutorial_active = false
	show_quota_only()
