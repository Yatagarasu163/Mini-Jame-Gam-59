extends HSlider

func _ready() -> void:
	value = GlobalWorldEnvironment.environment.adjustment_brightness

func _on_value_changed(value: float) -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = value
