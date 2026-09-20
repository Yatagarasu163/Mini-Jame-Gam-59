extends Node

var machineActive = false
var playerInRange = false
var playerNearOutput = false
var player = null
var currentPress = 0
var requiredPress = 0
var glowTween: Tween

# Cooking Values
var temperature: float = 20.0
var cookingProgress:float = 0.0

# Blending Values
var blendingProgress: float = 0.0
var blendingStarted = false
@export var blendingTime: float = 5.0

#Bottling Values
var bottleFill: float = 0.0
@export var bottleFillSpeed: float = 25.0

#Cooking Mini Game Reference
@export var minTemperature: float = 40.0
@export var maxTemperature: float = 80.0
@export var cookingTime: float = 5.0
@export var heatingSpeed: float = 25.0
@export var coolingSpeed: float = 10.0

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

# Cutting Mini Games UI References 
@export var cuttingProgressBar: ProgressBar
@export var keyIndicator: Panel
@export var keyLabel: Label
@export var instructionText: Label
@export var buttonGlow: Sprite2D
@export var cookingSpaceGlow: Sprite2D
@export var blenderSpaceGlow: Sprite2D
@export var bottlingSpaceGlow: Sprite2D
@export var outputItem: Area2D


# Cooking Mini Games UI References
@export var cookingUI: Control
@export var temperatureIndicator: Sprite2D
@export var temperatureBar: Sprite2D
@export var cookingProgressBar: ProgressBar

#Blending Mini Games UI References
@export var blenderUI: Control
@export var blendingProgressBar: ProgressBar
@export var  blendingLabel: Label

#Bottling Mini Games UI Reference
@export var bottlingUI: Panel
@export var ketchupFillBar: TextureProgressBar

func _ready():
	
	if machineType == MachineType.CUTTER:
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false
		buttonGlow.visible = false
		
	
	if machineType == MachineType.COOKING:
		cookingUI.visible = false
		
	if machineType == MachineType.BLENDER:
		blenderUI.visible = false
		
	if machineType == MachineType.BOTTLING:
		bottlingUI.visible = false	
		
		
		
func interact():
	GameManager.zoom_camera.emit(Vector2.ONE * 1.5)
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
				
				carriedItem.queue_free()
				startMiniGame()
			else:
				print("You need a Cut Tomato!")
			
		if machineType == MachineType.BLENDER:
			if player.enough_cooked_tomatoes():
				var carriedItem = player.get_node("CarryPoint/OutputItem")
				
				carriedItem.queue_free()
				startMiniGame()
			else:
				print("You need a Cooked Tomato!")
			
		if machineType == MachineType.BOTTLING:
			if player.enough_blended_tomatoes():
				var carriedItem = player.get_node("CarryPoint/OutputItem")
				
				carriedItem.queue_free()
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
	startGlowAnimation(buttonGlow)
	buttonGlow.visible = true
	
	cuttingProgressBar.max_value = requiredPress
	cuttingProgressBar.value = currentPress
	keyLabel.text = keyDisplayNames[selectedKeys]
	
	print("Machine Started")
	print("Required Presses: ", requiredPress)
	print("Selected Key: ", selectedKeys)
	
func startCookingGame():
	temperature = 20.0
	cookingProgress = 0.0
	cookingUI.visible = true
	cookingProgressBar.max_value = cookingTime
	cookingProgressBar.value = 0
	updateTemperatureIndicator()
	cookingSpaceGlow.visible = true
	startGlowAnimation(cookingSpaceGlow)
	
	
func startBlenderGame():
	blendingProgress = 0.0
	blendingStarted = false
	
	blenderUI.visible = true
	blendingProgressBar.max_value =  blendingTime
	blendingProgressBar.value = 0
	blenderSpaceGlow.visible = true
	startGlowAnimation(blenderSpaceGlow)

	print("Press SPACE to start blending")
	
func startBottlingGame():
	bottleFill = 0.0
	bottlingUI.visible = true	
	ketchupFillBar.min_value = 0
	ketchupFillBar.max_value = 100
	ketchupFillBar.value = 0
	bottlingSpaceGlow.visible = true
	startGlowAnimation(bottlingSpaceGlow)	

	

func chooseRandomKey():
	selectedKeys = possibleKeys.pick_random()
	
func startGlowAnimation(glowSprite):
	if glowTween:
		glowTween.kill()
	
	glowSprite.modulate.a = 1.0
	
	glowTween = create_tween()
	glowTween.set_loops()
	
	glowTween.tween_property(glowSprite, "modulate:a", 0.2, 0.5)
	glowTween.tween_property(glowSprite, "modulate:a", 1.0, 0.5)
	
func _process(delta: float) -> void:
	if playerNearOutput and outputItem.visible:
		if Input.is_action_just_pressed("interact"):
			pickupOutput()
	
	if machineActive == false:
		return
	
	if machineType != MachineType.BLENDER and playerInRange == false:
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
		GameManager.camera_shake.emit(1.0)
		currentPress += 1
		cuttingProgressBar.value = currentPress
		print(currentPress, "/", requiredPress)

		if currentPress >= requiredPress:
			completeMiniGame()
			
func updateCookingGame(delta):
	if Input.is_action_pressed("mash_space"):
		GameManager.camera_shake.emit(0.02)
		temperature += heatingSpeed * delta
	else:
		temperature -= coolingSpeed * delta
	
	temperature = clamp(temperature, 8.0, 100.0)
	updateTemperatureIndicator()
	
	if temperature >= minTemperature and temperature <= maxTemperature:
		cookingProgress += delta
		cookingProgressBar.value = cookingProgress
		
		if cookingProgress >= cookingTime:
			completeMiniGame()

func updateTemperatureIndicator():
	var startX = 430.0
	var moveDistance = 300.0
	
	temperatureIndicator.position.x = startX + ((temperature / 100.0) * moveDistance)
			
func updateBlendingGame(delta):
	
	if blendingStarted == false:
		if Input.is_action_just_pressed ("mash_space") and playerInRange:
			blendingStarted = true
			blendingLabel.text = "BLENDING....."
			print(("Blending Started"))
		return
		
	blendingProgress += delta
	blendingProgressBar.value = blendingProgress
	
	if blendingProgress >= blendingTime:
		completeMiniGame()

func updateBottlingGame(delta):
	if Input.is_key_pressed(KEY_SPACE):
		bottleFill += bottleFillSpeed * delta
		bottleFill = clamp(bottleFill, 0.0, 100.0)
		ketchupFillBar.value = bottleFill
		
		if bottleFill >= 100.0:
			completeMiniGame()
			

func completeMiniGame():
	machineActive = false
	
	if machineType == MachineType.CUTTER:
		player.finish_cutting()
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false
		
		if glowTween:
			glowTween.kill()
		buttonGlow.visible = false
		print("Cutting Complete")
		
	if machineType == MachineType.COOKING:
		player.finish_cooking()
		cookingUI.visible = false
		print("Cooking Completed")
		
	if machineType == MachineType.BLENDER:
		player.finish_blending()
		blenderUI.visible = false
		print("Blending Complete")
		
	if machineType == MachineType.BOTTLING:
		player.finish_bottling()
		bottlingUI.visible = false
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
		
	if machineType == MachineType.COOKING:
		cookingUI.visible = true

func hideMiniGameUI():
	if machineType == MachineType.CUTTER:
		cuttingProgressBar.visible = false
		keyIndicator.visible = false
		instructionText.visible = false
	
	if machineType == MachineType.COOKING:
		cookingUI.visible = false 

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body
		body.get_node("Interaction").setNearbyMachine(self)
		
		if machineActive:
			showMiniGameUI()
			


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.zoom_camera.emit(Vector2.ONE)
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
