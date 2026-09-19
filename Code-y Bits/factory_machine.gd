extends Node

var machineActive = false
var playerInRange = false
var playerNearOutput = false
var player = null
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
@export var outputItem: Area2D

func _ready():
	cuttingProgressBar.visible = false
	keyIndicator.visible = false
	instructionText.visible = false
	
func interact():
	if machineActive == false:
		
		if machineType == MachineType.CUTTER:
			if player.enough_fresh_tomatoes():
				player.get_node("CarryPoint/FreshTomato").visible = false
				startMiniGame()
			else:
				print("You need 5 tomatoes!")
		
		if machineType == MachineType.COOKING:
			if player.enough_cut_tomatoes():
				var carriedItem = player.get_node("CarryPoint/OutputItem")
				carriedItem.reparent(get_parent().get_node("CutterMachine/OutputPoint"))
				carriedItem.visible = false
				startMiniGame()
			else:
				print("You need a Cut Tomato!")
		
		if machineType == MachineType.BLENDER:
			if player.enough_cooked_tomatoes():
				var carriedItem = player.get_node("CarryPoint/OutputItem")
				carriedItem.reparent(get_parent().get_node("CookingMachine/OutputPoint"))
				carriedItem.visible = false
				startMiniGame()
			else:
				print("You need a Cooked Tomato!")
		
		if machineType == MachineType.BOTTLING:
			if player.enough_blended_tomatoes():
				var carriedItem = player.get_node("CarryPoint/OutputItem")
				carriedItem.reparent(get_parent().get_node("BlenderMachine/OutputPoint"))
				carriedItem.visible = false
				startMiniGame()
			else:
				print("You need a Blended Tomato!")
			
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
	completeMiniGame()
	
func startBlenderGame():
	completeMiniGame()
	
func startBottlingGame():
	completeMiniGame()

func chooseRandomKey():
	selectedKeys = possibleKeys.pick_random()
	
func _process(delta: float) -> void:
	if playerNearOutput and outputItem.visible:
		if Input.is_action_just_pressed("interact"):
			pickupOutput()
	
	if machineActive == false:
		return
	
	if playerInRange == false:
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

func pickupOutput():
	if machineType == MachineType.CUTTER:
		player.add_cut_tomato()
		
	if machineType == MachineType.COOKING:
		player.add_cooked_tomato()
		
	if machineType == MachineType.BLENDER:
		player.add_blended_tomato()
		
	if machineType == MachineType.BOTTLING:
		player.add_bottled_tomato()
		
	outputItem.reparent(player.get_node("CarryPoint"))
	outputItem.position = Vector2.ZERO
	outputItem.monitoring = false
	
	playerNearOutput = false
	print("Output Picked Up")
	
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
		player.finish_cutting()
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false
		print("Cutting Complete")
		
	if machineType == MachineType.COOKING:
		player.finish_cooking()
		print("Cooking Completed")
		
	if machineType == MachineType.BLENDER:
		player.finish_blending()
		print("Blending Complete")
		
	if machineType == MachineType.BOTTLING:
		player.finish_bottling()
		print("Bottling Complete")
	
	outputItem.reparent($OutputPoint)
	outputItem.position = Vector2.ZERO
	outputItem.visible = true
	outputItem.monitoring = true
	
	print("Machine Complete!")
	
func showMiniGameUI():
	if  machineType == MachineType.CUTTER:
		cuttingProgressBar.visible = true
		keyIndicator.visible = true
		instructionText.visible = true

func hideMiniGameUI():
	if machineType == MachineType.CUTTER:
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body
		body.get_node("Interaction").setNearbyMachine(self)
		
		if machineActive:
			showMiniGameUI()
			


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerInRange = false
		body.get_node("Interaction").notNearMachine()
		
		if machineActive:
			hideMiniGameUI()


func _on_output_item_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerNearOutput = true
		player = body

func _on_output_item_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerNearOutput = false
