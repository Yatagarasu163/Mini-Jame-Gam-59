extends Label

@onready var player_point: Label = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_point.text = "Point: " + str(Global.Player_Point);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_point.text = "Point: " + str(Global.Player_Point);
