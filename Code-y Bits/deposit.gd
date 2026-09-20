extends StaticBody2D
class_name deposit

var player_is_near: bool
var player: player_script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player.deposit_bottled_tomatoes():
		GameManager.add_progress(1)


func _on_interaction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_is_near = true
		player = body
		GameManager.zoom_camera.emit(Vector2.ONE * 1.5)


func _on_interaction_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_is_near = false
		GameManager.zoom_camera.emit(Vector2.ZERO)
