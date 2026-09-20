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
