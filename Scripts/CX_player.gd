extends CharacterBody2D
@onready var hurt_box: Area2D = $HurtBox

#for player movement speed
@export var speed = 100;
#for developers to assign the enemy note in the scene
#can replace this with the immortal toamto node
@export var enemy: Node2D = null;
#will turn to true when enemy's hitbox entered player's hurtbox 
var canStunEnemy = false;

#Player movement code
func handleInput():
	var moveDirection := Input.get_vector("MoveLeft", "MoveRight","MoveUp","MoveDown");
	velocity = moveDirection*speed;

func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	canHitEnemy()

#The attack function
func canHitEnemy():
	if(canStunEnemy && Input.is_action_just_pressed("Attack")):
		#call the enemy's stuning fucntion
		enemy.Stun();
		print("You hit the Enemy");
		#just incase you want the enemy to get knockback
		var push_directionX = sign(global_position.x - enemy.global_position.x)
		var push_directionY = sign(global_position.y - enemy.global_position.y)
		var push_strenght = 2
		enemy.pushback_velocity = Vector2(-push_directionX * push_strenght, -push_directionY * push_strenght)
		#the end of knockback code

#If enemy's hitbox entered player's hurtbox will set canStunEnemy to true
func _on_hurt_box_body_entered(body: Node2D) -> void:
	if(enemy.get_node("AngryTomatoHitBox")):
		print("You can stun the enemy")
		canStunEnemy = true;

#If enemy's hitbox exited player's hurtbox will set canStunEnemy to false
func _on_hurt_box_body_exited(body: Node2D) -> void:
	if(body.name == "AngryTomatoHitBox"):
		canStunEnemy = false;
