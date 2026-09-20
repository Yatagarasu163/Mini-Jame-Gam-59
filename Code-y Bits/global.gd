extends Node

var is_menu_open: bool = false
var options_menu_instance: Node = null

const OPTIONS_MENU_SCENE = preload("res://Scenes/options_menu.tscn")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	var current_scene = get_tree().current_scene
	
	if current_scene == null:
		return
	
	if current_scene.scene_file_path != "res://Scenes/main.tscn":
		return
	
	if event.is_action_pressed("ui_cancel"):
		toggle_options_menu()


func toggle_options_menu() -> void:
	is_menu_open = !is_menu_open
	
	if is_menu_open:
		options_menu_instance = OPTIONS_MENU_SCENE.instantiate()
		get_tree().root.add_child(options_menu_instance)
		
		options_menu_instance.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		options_menu_instance.exit_option_menu.connect(toggle_options_menu)
		
		get_tree().paused = true
		
	else:
		if is_instance_valid(options_menu_instance):
			options_menu_instance.queue_free()
		
		get_tree().paused = false
