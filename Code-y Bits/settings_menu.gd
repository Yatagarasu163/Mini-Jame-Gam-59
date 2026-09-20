class_name SettingsMenu
extends Control

@onready var exit_button: Button = %ExitButton

signal exit_option_menu

func _ready() -> void:
	exit_button.pressed.connect(on_exit_pressed)

func on_exit_pressed() -> void:
	exit_option_menu.emit()
