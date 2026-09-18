extends Node

var nearbyMachine = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if nearbyMachine != null:
			nearbyMachine.interact()
			
func setNearbyMachine(machine):
	nearbyMachine = machine

func notNearMachine():
	nearbyMachine = null
