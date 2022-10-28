extends "res://Game_Objects/Enemies/Enemy_Parent_Scene.gd"

func _ready():
	hit_points = 50
	attack_damage = 4
	attack_range = 112
	attack_anim_speed = 0.75
	
	walk_speed = 100
	
	.randomize_walk_speed()
