extends Node2D

var player_in_range: bool

func _ready() -> void:
	hide()
	GameManager.spawn_exit.connect(show)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and GameManager.is_in_overtime:
		GameManager.end_shift_manually()
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://End Screen.tscn")

func _on_interaction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range= true
		GameManager.zoom_camera.emit(Vector2.ONE * 1.5)

func _on_interaction_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range= true
		GameManager.zoom_camera.emit(Vector2.ZERO)
