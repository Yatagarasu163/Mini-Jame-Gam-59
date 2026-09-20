extends CharacterBody2D

#Default values for BIG T
#Variables for target, current quota and current level
@export var quota: int = 0
@export var level: int = 1
@export var target: Node2D = null
@export var speed_scale = 0.2
@export var size_scale = 0.05
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var big_t: CharacterBody2D = $"."
var speed = 150
var last_known_position: Vector2 = Vector2.ZERO
var is_searching_last_location: bool = false
var current_target_spot: Node2D = null

#LOS check range requires manual changing of the Raycast2D x value in its prefab
#Currently LOS checks a circle around BIG T can change if needed
@onready var los: RayCast2D = $RayCast2D

func _ready() -> void:
# Wait a frame to ensure the tile generation script has finished spawning markers
	await get_tree().process_frame
	call_deferred("choose_random_spot")

# Called every frame. Moves towards the target
func _physics_process(_delta: float) -> void:
	if target:
		#raycast always points to the target
		los.target_position = to_local(target.global_position)
		
		if los.is_colliding() and los.get_collider() == target:
			# CHASE STATE: Target is in Line of Sight
			last_known_position = target.global_position
			is_searching_last_location = false
			move_towards_target(last_known_position)
		else:
			# LOST LOS STATE: Start tracking to the last known position
			is_searching_last_location = true
		
	if is_searching_last_location:
		search_last_location()
		
	
func move_towards_target(target_pos):
	#part of code that moves BIG T to the last known player location/POI
	navigation_agent.target_position = target_pos
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * (speed * ((quota/2 + level) * speed_scale))
	move_and_slide()

func search_last_location():
	# Move toward the last spot the Target was seen
	move_towards_target(last_known_position)
	
	# Check if the enemy has arrived close enough to the last known location
	if global_position.distance_to(last_known_position) <= 30.0:
		is_searching_last_location = false
		velocity = Vector2.ZERO
		# IDLE ANIMATION AND PATROL CODE NOT ADDED YET
		choose_random_spot()

func choose_random_spot() -> void:
	# 1. Fetch all currently generated markers from the group
	var spots: Array[Node] = get_tree().get_nodes_in_group("patrol_spots")
	
	if spots.is_empty():
		return
		
	# 2. Pick a random one
	var random_index: int = randi() % spots.size()
	current_target_spot = spots[random_index] as Marker2D
	
	if current_target_spot:
		last_known_position = current_target_spot.global_position

func _process(delta: float) -> void:
	#Code that scales BIG T's size as the game goes on
	var size = 1 + ((quota + level) * size_scale)
	var target_scale = Vector2(size, size)
	big_t.scale = big_t.scale.lerp(target_scale,5.0 * delta)
