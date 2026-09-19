extends Node

var machineActive = false
var currentPress = 0
var requiredPress = 0

@export var minPresses: int = 10
@export var maxPresses: int = 20
var possibleKeys = ["mash_f","mash_r","mash_space","mash_q","mash_v","mash_z"]
var keyDisplayNames = {
	"mash_f": "F",
	"mash_r": "R",
	"mash_space": "SPACE",
	"mash_q": "Q",
	"mash_v": "V",
	"mash_z": "Z"
}
var selectedKeys = ""
enum MachineType { CUTTER,COOKING,BLENDER,BOTTLING}
@export var machineType : MachineType

@export var cuttingProgressBar: ProgressBar
@export var keyIndicator: Panel
@export var keyLabel: Label
@export var instructionText: Label

func _ready():
	cuttingProgressBar.visible = false
	keyIndicator.visible = false
	instructionText.visible = false
func interact():
	if machineActive == false:
		startMiniGame()
			
func startMiniGame():
	machineActive = true
	
	match machineType:
		MachineType.CUTTER:
			startCuttingGame()
		
		MachineType.COOKING:
			startCookingGame()
			
		MachineType.BLENDER:
			startBlenderGame()
			
		MachineType.BOTTLING:
			startBottlingGame()
			
func startCuttingGame():
	currentPress = 0
	requiredPress = randi_range(minPresses,maxPresses)
	chooseRandomKey()
	cuttingProgressBar.visible = true
	keyIndicator.visible = true
	instructionText.visible = true
	
	cuttingProgressBar.max_value = requiredPress
	cuttingProgressBar.value = currentPress
	keyLabel.text = keyDisplayNames[selectedKeys]
	
	print("Machine Started")
	print("Required Presses: ", requiredPress)
	print("Selected Key: ", selectedKeys)
	
func startCookingGame():
	pass
	
func startBlenderGame():
	pass
	
func startBottlingGame():
	pass

func chooseRandomKey():
	selectedKeys = possibleKeys.pick_random()
	
func _process(delta: float) -> void:
	if machineActive == false:
		return
	
	match machineType:
		MachineType.CUTTER:
			updateCuttingGame()
		
		MachineType.COOKING:
			updateCookingGame(delta)
			
		MachineType.BLENDER:
			updateBlendingGame(delta)
		
		MachineType.BOTTLING:
			updateBottlingGame(delta)
		
func updateCuttingGame():
	if Input.is_action_just_pressed(selectedKeys):
		currentPress += 1
		cuttingProgressBar.value = currentPress

		print(currentPress, "/", requiredPress)

		if currentPress >= requiredPress:
			completeMiniGame()
			
func updateCookingGame(delta):
	pass
	
func updateBlendingGame(delta):
	pass

func updateBottlingGame(delta):
	pass
				
func completeMiniGame():
	machineActive = false
	
	if machineType == MachineType.CUTTER:
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false
	
	print("Machine Complete!")					


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Interaction").setNearbyMachine(self)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Interaction").notNearMachine()


		
