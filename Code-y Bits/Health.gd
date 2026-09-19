extends Node
var maxHealth = 100
var currentHealth = maxHealth


func take_damage(damageAmount):
	currentHealth -= damageAmount

	if currentHealth <= 0:
		currentHealth = 0
		die()
	
func heal_player(healAmount):	
	currentHealth += healAmount
	
	if currentHealth > maxHealth:
		currentHealth = maxHealth
			
func die():
	print("PlayerDead")
