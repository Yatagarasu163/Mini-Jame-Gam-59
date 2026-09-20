extends CanvasLayer

#region /// on ready variable

#container
@onready var main_menu: VBoxContainer = %MainMenu
@onready var options_menu: OptionsMenu = $Options_Menu

#buttons
@onready var start_game: Button = %StartGame
@onready var setting_button: Button = %SettingButton
@onready var exit: Button = %ExitButton
@onready var start_level = preload("res://Scenes/main_game.tscn") as PackedScene #put the main scene in this

#endregion

func _ready() -> void: 
	handle_connecting_signal()

func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed( "ui_cancel" ):
		if main_menu.visible == false:
			on_exit_options_menu()

func start_new_game() -> void:
	get_tree().change_scene_to_packed(start_level)
	pass

func open_settings() -> void:
	main_menu.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func quit_game() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	main_menu.visible = true 
	options_menu.visible = false

func handle_connecting_signal() -> void:
	start_game.button_down.connect( start_new_game )
	setting_button.button_down.connect( open_settings )
	exit.button_down.connect( quit_game )
	options_menu.exit_option_menu.connect( on_exit_options_menu )
