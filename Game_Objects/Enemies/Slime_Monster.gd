extends "res://Game_Objects/Enemies/Enemy_Parent_Scene.gd"

# This is for the first type of enemy, the common


func _ready():
	hit_points = 20
	attack_damage = 1
	attack_range = 90
	attack_anim_speed = 1
	
	walk_speed = 200
	
	cash_value = 5
	
	.randomize_walk_speed()
	
	# Setting up its weaknesses & strengths
	damage_effectors = {
		"weaknesses": {
			"fire": 0.1,
			"ice": 0.25
		},
		"strengths": {
			"explosion": 0.15,
			"pierce": 0.85
		}
	}
	print("From slime monster")
	print(damage_effectors)
	

## Check if the enemy's attack animation has finished, then play the next randomized attack animation
#func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
#	print("Test from SLIME")
#
#	.anim_finished(anim_name)
