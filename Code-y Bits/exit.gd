extends StaticBody2D

var player_in_range: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		GameManager.end_shift_manually()


func _on_interaction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range= true
		GameManager.zoom_camera.emit(Vector2.ONE * 1.5)

func _on_interaction_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range= true
		GameManager.zoom_camera.emit(Vector2.ZERO)
