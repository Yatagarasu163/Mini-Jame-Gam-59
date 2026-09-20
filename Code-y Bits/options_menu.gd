class_name OptionsMenu
extends CanvasLayer

@onready var exit_button: Button = %ExitButton

signal exit_option_menu

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	exit_option_menu.emit()
	set_process(false)
