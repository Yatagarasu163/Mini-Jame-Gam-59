extends Button

@export var previous_Skill: Control = null
@export var point_Needed = 0;
var skillUnlock = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if(previous_Skill != null):
		if(previous_Skill.skillUnlock == true):
			if(Global.Player_Point >= point_Needed):
				print("Player able to unlock the skill");
				Global.Player_Point -= point_Needed;
				skillUnlock = true;
			else:
				print("Player have not enough point to unlock the skill");
		else:
			print("you have to unlock previous skill to upgrade this skill");
	else:
		print("this is the first skill of the skill tree");
		if(Global.Player_Point >= point_Needed):
			print("Player able to unlock the skill");
			Global.Player_Point -= point_Needed;
			skillUnlock = true;
		else:
			print("Player have not enough point to unlock the skill");
