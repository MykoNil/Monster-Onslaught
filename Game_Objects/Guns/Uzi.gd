extends "res://Game_Objects/Guns/Gun.gd"

var shot_debounce_time = 0


func _ready():
	damage = 1
	shots_per_second = 60
	gun_name = "Uzi"
	
	
	bullet_type = straight_bullet_1
	
	# Bullets are fired at a fast rate
	is_rapid_fire = true
#	shot_debounce_time = primary_shot_debounce_time


func shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs):
#	print("This is the child")
	.shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs)	
	
	
	
#	print("This is the parent")
#	if is_rapid_fire:
#		$PrimaryShotDebounceTimer.start(shot_debounce_time)
	$PrimaryShotDebounceTimer.start(primary_shot_debounce_time)
