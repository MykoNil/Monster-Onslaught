extends "res://Game_Objects/Enemies/Enemy_Parent_Scene.gd"

# This is for the first type of enemy, the common


func _ready():
	hit_points = 10
	attack_damage = 1
	attack_range = 90
	attack_anim_speed = 1
	
	walk_speed = 200
	
	.randomize_walk_speed()
