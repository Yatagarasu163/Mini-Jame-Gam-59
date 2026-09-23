extends Node

@export var collectionTime: float = 5.0
@export var collectionProgressBar: ProgressBar
@export var freshTomato: Area2D


var collectionProgress: float = 0.0
var playerInRange: bool = false
var isCollecting: bool = false
var tomatoReady: bool = false
var playerNearTomato: bool = false
var player = null

#Interaction and Pickup Text references
@export var interactionPrompt: Node2D
@export var pickupPrompt: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collectionProgressBar.visible = false
	freshTomato.visible = false
	pickupPrompt.visible = false

	collectionProgressBar.min_value = 0
	collectionProgressBar.max_value = collectionTime
	collectionProgressBar.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerNearTomato and  tomatoReady:
		if Input.is_action_just_pressed("interact"):
			pickupTomato()
			
	if isCollecting == false:
		return
	
	if playerInRange == false:
		return
	
	collectionProgress += delta
	collectionProgressBar.value = collectionProgress
	
	if collectionProgress >= collectionTime:
		collectTomato()

func interact():
	if isCollecting:
		return
	
	if tomatoReady:
		print("Pick up Tomatoes First")
		return
	
	if player._tomato_fresh >= player._max_tomatoes:
		print("Fresh Tomato inventory is full!")
		return
		
	isCollecting = true
	collectionProgress = 0.0
	interactionPrompt.visible = false
	
	collectionProgressBar.value = 0
	collectionProgressBar.visible = true
	
	print ("Collecting tomato....")
		

func collectTomato():
	freshTomato.reparent($OutputPoint)
	freshTomato.position = Vector2.ZERO
	freshTomato.visible = true
	tomatoReady = true
	
	if playerNearTomato:
		pickupPrompt.visible = true
	
	isCollecting = false
	collectionProgress = 0.0
	
	collectionProgressBar.visible = false
	collectionProgressBar.value = 0
	
	print("Fresh Tomato produced!")
	
func pickupTomato():
	player.add_fresh_tomato()
	
	freshTomato.reparent(player.get_node("CarryPoint"))
	freshTomato.position = Vector2.ZERO
	tomatoReady = false
	playerNearTomato = false
	pickupPrompt.visible = false
	print("Fresh Tomatoes Picked Up!")
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body
		interactionPrompt.visible = true
		body.get_node("Interaction").setNearbyMachine(self)
	
	if isCollecting:
		collectionProgressBar.visible = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerInRange = false
		body.get_node("Interaction").notNearMachine()
		interactionPrompt.visible = false
		
	if isCollecting:
		collectionProgressBar.visible = false


func _on_fresh_tomato_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		playerNearTomato = true
		player = body
	if tomatoReady:	
		pickupPrompt.visible = true


func _on_fresh_tomato_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerNearTomato = false
		pickupPrompt.visible = false
		
