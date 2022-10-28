extends Sprite


signal shoot



# Get scenes
var straight_bullet_1 = preload("res://Game_Objects/Projectiles/Straight_Bullet_1.tscn")
var homing_missile_1 = preload("res://Game_Objects/Projectiles/Homing_Missile_1.tscn")
var piercing_bullet_1 = preload("res://Game_Objects/Projectiles/Pierce_Bullet.tscn")

# Gun variables
export var primary_shot_debounce_time = 0.025
export var secondary_shot_debounce_time = 1

# Variables for type of shooting
var is_rapid_fire = false
var manual_debounce_cancel = false
var trigger_released = true
var can_shoot = true

var primary_shot_debounce = false
var secondary_shot_debounce = false

var gun_muzzle = null

var primary_shot_name = "Primary"
var secondary_shot_name = "Secondary"

var shot_type_global

var is_held = true
var player_node

var look_direction
var mouse_position

var bullet_type
var bullet_directions = []

var arena_node

var gun_name = "Gun"
var damage = 1
var shots_per_second = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print("This is from the parent scene")
	player_node = $"../../Player" # This potentially causes the player to start the game with no gun
	if not player_node:
		set_physics_process(false)
		queue_free()
	gun_muzzle = get_node("Position2D")
	arena_node = get_tree().get_root().get_node("Main/Arena1")#player_node.get_parent()
	
	# Temporary, for testing
	bullet_type = homing_missile_1
	
	# Emit signal to the shop menu
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_position = get_global_mouse_position()
	look_direction = mouse_position - player_node.position
	
	var look_dir_length = look_direction.length()
	look_direction = atan2(look_direction.y, look_direction.x)
	
	var point_from_gun_to_mouse = mouse_position - global_position
	var gun_point_to_mouse_length = point_from_gun_to_mouse.length()
	
	if trigger_released and not primary_shot_debounce:
		can_shoot = true
	
	if is_held:
		if Input.is_action_pressed("mouse_button1_click"):
			trigger_released = false
			if not primary_shot_debounce and can_shoot:
				
				shoot_gun(look_direction, point_from_gun_to_mouse, bullet_type, bullet_directions)
		elif Input.is_action_just_released("mouse_button1_click"):
			if not is_rapid_fire and manual_debounce_cancel:
				primary_shot_debounce = false
				trigger_released = true
			elif not is_rapid_fire:
				pass
				trigger_released = true
	
	


#func _on_Gun_shoot(look_direction, point_from_gun_to_mouse) -> void:
#	if Input.is_action_pressed("mouse_button1_click"):
#		if not primary_shot_debounce:
#			shoot_gun(look_direction, point_from_gun_to_mouse, straight_bullet_1)
	
#	if Input.is_action_pressed("mouse_button2_click"):
#		if not secondary_shot_debounce:
#			shoot_gun(look_direction, point_from_gun_to_mouse, secondary_shot_name)
	

func rotate_vector(vector2, angle):
	var angle_in_rad = deg2rad(angle)
	
	var x_prime = vector2.x * cos(angle_in_rad) - vector2.y * sin(angle_in_rad)
	var y_prime = vector2.x * sin(angle_in_rad) + vector2.y * cos(angle_in_rad)
	
	var rotated_vector = Vector2(x_prime, y_prime)
	return rotated_vector


# Instantiates a bullet from the given bullet scene and sets its direction
func shoot_bullet(bullet_scene, shot_direction):
	var bullet = bullet_scene.instance()
	bullet.init(gun_muzzle.global_position, shot_direction)
	arena_node.add_child(bullet)

# For shooting with the gun
func shoot_gun(look_direction, point_from_gun_to_mouse, bullet_scene, bullet_dirs):
	var point_from_gun_to_shoot = gun_muzzle.global_position - global_position
	
	# Consider handling the bullet spawning elsewhere. Maybe in separate node like the gun (Since guns will change based on equipped) ** DONE **
#	var bullet
	
	
	# Cast ray in the direction the player is trying to shoot
#	print("Shot")
##	var shot_debounce_time = 0
#
#
#	shot_debounce_time = primary_shot_debounce_time
#
#	print("This is the parent")
##	if is_rapid_fire:
##		$PrimaryShotDebounceTimer.start(shot_debounce_time)
	
	primary_shot_debounce = true
	
	# If the array of directions has something in it
	if not bullet_dirs.size() > 0:
		shoot_bullet(bullet_scene, point_from_gun_to_shoot)#point_from_gun_to_mouse
	else:
		# spawn as many bullets at as many directions defined
		for direction in bullet_dirs:
			print(direction)
			shoot_bullet(bullet_scene, direction)
#			print(sqrt(pow(direction.normalized().x, 2) + pow(direction.normalized().y, 2)))
	
	
#	if shot_type == primary_shot_name:
#		shot_debounce_time = primary_shot_debounce_time
#		primary_shot_debounce = true
#		bullet = straight_bullet_1.instance()
#		$PrimaryShotDebounceTimer.start(primary_shot_debounce_time)
#	elif shot_type == secondary_shot_name:
#		shot_debounce_time = secondary_shot_debounce_time
#		secondary_shot_debounce = true
#		bullet = homing_missile_1.instance()
#		$SecondaryShotDebounceTimer.start(secondary_shot_debounce_time)
	
	# Activate shot debounce timer
#	$ShotDebounceTimer.start(shot_debounce_time)#rng.randf_range(0.025, 0.25))
	
	
	


func _on_PrimaryShotDebounceTimer_timeout() -> void:
	primary_shot_debounce = false

func _on_SecondaryShotDebounceTimer_timeout() -> void:
	secondary_shot_debounce = false


