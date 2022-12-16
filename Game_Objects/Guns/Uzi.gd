extends "res://Game_Objects/Guns/Gun.gd"

var shot_debounce_time = 0


func _ready():
	bullet_type = straight_bullet_1
	
	var bullet_info = .get_bullet_info()
	
	damage = bullet_info.damage_per_shot
	shots_per_second = bullet_info.shots_per_second
	cost = 15
	
	gun_name = "Uzi"
	shop_description = "This miniature devestator has the power to fire 40 times per second!"
	
	
	
	# Bullets are fired at a fast rate
	is_rapid_fire = true
#	shot_debounce_time = primary_shot_debounce_time


func shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs):
#	print("This is the child")
	.shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs)	
	
	
	
#	print("This is the parent")
#	if is_rapid_fire:
#		$PrimaryShotDebounceTimer.start(shot_debounce_time)
	start_count = true
	debounce_timer_counter = 0
	$PrimaryShotDebounceTimer.start(primary_shot_debounce_time)
