extends "res://Game_Objects/Guns/Gun.gd"

#Yo
func _ready():
	bullet_type = piercing_bullet_1
	primary_shot_debounce_time = 1.15#0.125#1.15#0.5
	
#	print("Shotgun############")
	var bullet_info = .get_bullet_info()
	
#	print("OH noooooooooooooo")
	shots_per_second = bullet_info.shots_per_second
	hits_per_shot = bullet_info.hits_per_shot
	damage = bullet_info.damage_per_shot * 4
	cost = 350
	
	# Bullet overrides
	bullet_damage = 10
	bullet_hp = 3
	bullet_knockback_strength = 15 * 60 # x pixels per frame (converted into pixels per second)
	
	# Gun clips/ammo
	clip_max_size = 5 # 4 bullets per shot, so 20 bullets = (20 / 4) = 5 shots per clip ---- Maybe just do it as cartridges
	clip_size = clip_max_size
	ammo = clip_size * 5
#	print(damage)
#	print(bullet_info)
	
	gun_name = "Shotgun"
	shop_description = "This gun'll blow through any enemy!"
	
#	shot_debounce_time = primary_shot_debounce_time



func shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs):
	var point_from_gun_to_muzzle = gun_muzzle.global_position - global_position
#	print("This is the child: Shotgun")
	
	bullet_directions = [
#		point_from_gun_to_mouse,
#		rotate_vector(point_from_gun_to_mouse, 2),,,,,,,
#		point_from_gun_to_mouse
		rotate_vector(point_from_gun_to_muzzle, 2),
		rotate_vector(point_from_gun_to_muzzle, -2),
		rotate_vector(point_from_gun_to_muzzle, 5),
		rotate_vector(point_from_gun_to_muzzle, -5),
	]
	.shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, 	bullet_directions)
	
#	trigger_released = false

	can_shoot = false
	$PrimaryShotDebounceTimer.start(primary_shot_debounce_time)


func rotate_vector(vector2, angle):
	var angle_in_rad = deg2rad(angle)
	
	var x_prime = vector2.x * cos(angle_in_rad) - vector2.y * sin(angle_in_rad)
	var y_prime = vector2.x * sin(angle_in_rad) + vector2.y * cos(angle_in_rad)
	
	var rotated_vector = Vector2(x_prime, y_prime)
	return rotated_vector
