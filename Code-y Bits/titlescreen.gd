extends CanvasLayer

#region /// on ready variable

#container
@onready var main_menu: VBoxContainer = %MainMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu

#buttons
@onready var start_game: Button = %StartGame
@onready var setting_button: Button = %SettingButton
@onready var exit: Button = %Exit
@onready var music_slider: HSlider = %MusicControl
@onready var sfx_slider: HSlider = %SfxControl
@onready var brightness_slider: HSlider = %BrightnessControl

#endregion

func _ready() -> void: 
	start_game.pressed.connect( start_new_game )
	setting_button.pressed.connect( show_settings_button )
	show_main_menu()
	pass

func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed( "ui_cancel" ):
		if main_menu.visible == false:
			show_main_menu()
	pass

func show_main_menu() -> void:
	main_menu.visible = true
	settings_menu.visible = false
	start_game.grab_focus()
	pass 

func start_new_game() -> void:
	#start game logic
	
	pass

func show_settings_button() -> void:
	main_menu.visible = false
	settings_menu.visible = true
	music_slider.grab_focus()
	
	pass
