extends CharacterBody2D
@onready var hurt_box: Area2D = $HurtBox
@onready var hurt_box_collision: CollisionShape2D = $HurtBox/HurtBoxCollision


@export var speed = 100;

func handleInput():
	var moveDirection := Input.get_vector("Left", "Right","Up","Down");
	velocity = moveDirection*speed;
	if(Input.is_action_just_pressed("Attack")):
		hurt_box_collision.disabled = false;


func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if(body.name == "AngryTomatoHitBox"):
		print("Angry Tomato is in range")
		if(Input.is_action_just_pressed("Attack")):
			print("You hit the Angry Tomato")
