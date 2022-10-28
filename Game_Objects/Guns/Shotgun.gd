extends "res://Game_Objects/Guns/Gun.gd"

#Yo
func _ready():
	damage = 8
	shots_per_second = 4 * 2
	gun_name = "Shotgun"
	
	bullet_type = piercing_bullet_1
#	shot_debounce_time = primary_shot_debounce_time
	primary_shot_debounce_time = 0.5


func shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs):
	var point_from_gun_to_muzzle = gun_muzzle.global_position - global_position
#	print("This is the child: Shotgun")
	
	bullet_directions = [
#		point_from_gun_to_mouse,
#		rotate_vector(point_from_gun_to_mouse, 2),
		rotate_vector(point_from_gun_to_muzzle, 2),
		rotate_vector(point_from_gun_to_muzzle, -2),
		rotate_vector(point_from_gun_to_muzzle, 5),
		rotate_vector(point_from_gun_to_muzzle, -5),
	]
	.shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_directions)
	
#	trigger_released = false
	can_shoot = false
	$PrimaryShotDebounceTimer.start(primary_shot_debounce_time)


func rotate_vector(vector2, angle):
	var angle_in_rad = deg2rad(angle)
	
	var x_prime = vector2.x * cos(angle_in_rad) - vector2.y * sin(angle_in_rad)
	var y_prime = vector2.x * sin(angle_in_rad) + vector2.y * cos(angle_in_rad)
	
	var rotated_vector = Vector2(x_prime, y_prime)
	return rotated_vector
