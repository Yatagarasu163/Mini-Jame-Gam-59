extends Node

var machineActive = false
var currentPress = 0
var requiredPress = 0

@export var minPresses: int = 10
@export var maxPresses: int = 20
var possibleKeys = ["mash_f","mash_g","mash_h","mash_j","mash_k","mash_l"]
var selectedKeys = ""



func interact():
	if machineActive == false:
		startMiniGame()
			
func startMiniGame():
	machineActive = true
	currentPress = 0
	chooseRandomKey()
	requiredPress = randi_range(minPresses,maxPresses)
	print("Machine Started")
	print("Required Presses: ", requiredPress)
	print("Selected Key: ", selectedKeys)

func chooseRandomKey():
	selectedKeys = possibleKeys.pick_random()
	
func _process(delta: float) -> void:
	if machineActive:
		if Input.is_action_just_pressed(selectedKeys):
			currentPress += 1
			print(currentPress, "/", requiredPress)
			if currentPress >= requiredPress:
				completeMiniGame()
			
func completeMiniGame():
	machineActive = false
	
	print("Machine Complete!")					


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Interaction").setNearbyMachine(self)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Interaction").notNearMachine()


		
