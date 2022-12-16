extends "res://Game_Objects/Enemies/Enemy_Parent_Scene.gd"

func _ready():
	hit_points = 85
	armor = 5 # By percentage perhaps?
	
	attack_damage = 4
	attack_range = 112
	attack_anim_speed = 0.75
	
	walk_speed = 120
	
	cash_value = 15
	
	.randomize_walk_speed()
	
	# Setting up its weaknesses & strengths
	damage_effectors = {
		"weaknesses": {
			"fire": 0.1,
			"ice": 0.25
		},
		"strengths": {
			"explosion": 0.15
		}
	}


## Check if the enemy's attack animation has finished, then play the next randomized attack animation
#func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
#	print("Test from ROCK")
#
#	.anim_finished(anim_name)
