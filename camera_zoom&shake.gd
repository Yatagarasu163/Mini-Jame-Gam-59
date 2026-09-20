extends Camera2D

# --- ZOOM INSPECTOR PARAMETERS ---
@export_group("Zoom Settings")
## Default zoom level when normal gameplay resumes
@export var default_zoom: Vector2 = Vector2(1.0, 1.0)
## Duration in seconds to transition zoom
@export var default_zoom_duration: float = 0.3
## Easing trans type for smooth zoom transitions
@export var zoom_trans_type: Tween.TransitionType = Tween.TRANS_SINE

# --- SHAKE INSPECTOR PARAMETERS ---
@export_group("Shake Settings")
## Maximum pixel offset during maximum shake strength
@export var max_shake_offset: Vector2 = Vector2(16.0, 16.0)
## Decay speed (1.0 = shake fades completely in 1 second)
@export var shake_decay: float = 2.0

var active_zoom_tween: Tween
var current_shake_strength: float = 0.0

func _ready() -> void:
	zoom = default_zoom

func _process(delta: float) -> void:
	# Decay shake over time and apply random pixel offset
	if current_shake_strength > 0.0:
		current_shake_strength = max(0.0, current_shake_strength - (shake_decay * delta))
		offset = Vector2(
			randf_range(-max_shake_offset.x, max_shake_offset.x) * current_shake_strength,
			randf_range(-max_shake_offset.y, max_shake_offset.y) * current_shake_strength
		)
	else:
		offset = Vector2.ZERO

# --- GLOBAL FUNCTION 1: ZOOM ---
## Smoothly zooms camera to target_zoom level. Pass Vector2.ZERO to reset to default.
func zoom_camera(target_zoom: Vector2 = Vector2.ZERO, duration: float = -1.0) -> void:
	if target_zoom == Vector2.ZERO:
		target_zoom = default_zoom
	if duration <= 0.0:
		duration = default_zoom_duration

	if active_zoom_tween and active_zoom_tween.is_running():
		active_zoom_tween.kill()

	active_zoom_tween = create_tween().set_trans(zoom_trans_type).set_ease(Tween.EASE_OUT)
	active_zoom_tween.tween_property(self, "zoom", target_zoom, duration)

# --- GLOBAL FUNCTION 2: SHAKE ---
## Triggers screen shake. Strength scales from 0.0 to 1.0.
func shake_camera(strength: float = 1.0) -> void:
	current_shake_strength = clamp(current_shake_strength + strength, 0.0, 1.0)
