extends CanvasLayer

@onready var fail_screen: = $"Fail Screen"
@onready var shift_screen: = $"Next Shift Screen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.player_living:
		shift_screen.show()
		fail_screen.hide()
	else:
		shift_screen.hide()
		fail_screen.show()


func _on_end_here_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/titlescreen.tscn")


func _on_next_shift_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/titlescreen.tscn")
