extends Sprite


signal shoot



# Get scenes
var straight_bullet_1 = preload("res://Game_Objects/Projectiles/Straight_Bullet_1.tscn")
var homing_missile_1 = preload("res://Game_Objects/Projectiles/Homing_Missile_1.tscn")
var piercing_bullet_1 = preload("res://Game_Objects/Projectiles/Pierce_Bullet.tscn")

# Gun variables
export var primary_shot_debounce_time = 0.025 # 1(second) / 40(frames or repetitions per second) #0.01
export var secondary_shot_debounce_time = 1

var debounce_timer_counter = 0
var start_count = false

# Variables for type of shooting
var is_rapid_fire = false
var manual_debounce_cancel = false
var trigger_released = true
var can_shoot = true

var need_to_reload = false

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
var guns_handler_node

var gun_name = "Gun"
var shop_description = "A brief explanation of what type of gun this is."
var damage = 1
var shots_per_second = 1
var hits_per_shot = 1
var cost = 1
# Gun clips/ammo
var clip_max_size = 60
var clip_size = clip_max_size setget set_clip_size
var ammo = 180 setget set_ammo

var reload_time = 2

var HUD_node
var reload_timer_node


var survey_rate_of_shot_timer_counter = 0
var survey_rate_of_shot_counter = 0
var survey_rate_of_shot_results = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print("FPS: " + str(Engine.get_framse_per_second()))
#	print("This is from the parent scene")
	player_node = $"../../Player" # This potentially causes the player to start the game with no gun
	if not player_node:
		set_process(false)
#		queue_free()
	gun_muzzle = get_node("Position2D")
	arena_node = get_tree().get_root().get_node("Main/Arena1")#player_node.get_parent()
	guns_handler_node = get_tree().get_root().get_node("Main/Arena1/GunsHandler")
	HUD_node = get_tree().get_root().get_node("Main/Arena1/HUD")
	
	reload_timer_node = $ReloadTimer
	
	# Temporary, for testing
	bullet_type = homing_missile_1
#	print("Parent############")
	# Emit signal to the shop menu
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	print("FPS: " + str(delta * 60))

	if start_count:
		debounce_timer_counter += 1
	
	mouse_position = get_global_mouse_position()
	look_direction = mouse_position - player_node.position
	
	var look_dir_length = look_direction.length()
	look_direction = atan2(look_direction.y, look_direction.x)
	
	var point_from_gun_to_mouse = mouse_position - global_position
	var gun_point_to_mouse_length = point_from_gun_to_mouse.length()
	
#	if not need_to_reload:
	if trigger_released and not primary_shot_debounce:
		can_shoot = true
	
	if is_held:
		if Input.is_action_pressed("mouse_button1_click"):
#			survey_speed_of_shot(delta)
			trigger_released = false
			if not primary_shot_debounce and can_shoot:# and not need_to_reload:
				
				shoot_gun(look_direction, point_from_gun_to_mouse, bullet_type, bullet_directions)
		elif Input.is_action_just_released("mouse_button1_click"):
#			if not need_to_reload:
			if not is_rapid_fire and manual_debounce_cancel:
				primary_shot_debounce = false
				trigger_released = true
			elif not is_rapid_fire:
				pass
				trigger_released = true
#	else:
#		print("Out of ammo. Need to reload.")
	
	if Input.is_action_just_pressed("reload_gun"):
		reload_gun()
	

func reload_gun():
	reload_timer_node.start(reload_time)


func survey_speed_of_shot(delta):
	if survey_rate_of_shot_timer_counter >= 60:
		survey_rate_of_shot_timer_counter = 0
		survey_rate_of_shot_results.push_back(survey_rate_of_shot_counter)
		survey_rate_of_shot_counter = 0
	else:
		survey_rate_of_shot_timer_counter += 1
	
	if survey_rate_of_shot_results:
		if survey_rate_of_shot_results.size()-1 >= 5:
			var sum_of_rates = 0
			for rate in survey_rate_of_shot_results:
				sum_of_rates += rate
				print("Shot rate results: " + str(rate))
			print("With an average of " + str((sum_of_rates) / survey_rate_of_shot_results.size()-1) + " shots per second")
			survey_rate_of_shot_results = []

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
	survey_rate_of_shot_counter += 1
	var bullet = bullet_scene.instance()
	bullet.initialize()
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
	if not need_to_reload and clip_size > 0:
		if not bullet_dirs.size() > 0:
			shoot_bullet(bullet_scene, point_from_gun_to_shoot)#point_from_gun_to_mouse
		else:
			# spawn as many bullets at as many directions defined
			for direction in bullet_dirs:
	#			print(direction)
				shoot_bullet(bullet_scene, direction)
	#			print(sqrt(pow(direction.normalized().x, 2) + pow(direction.normalized().y, 2)))
	
	# Deal with clip and ammo -------------------------
	if clip_size > 0:
		self.clip_size -= 1
	if clip_size < 0:
		clip_size = 0
	
	if clip_size <= 0: # Out of ammo. Can't shoot. Must reload.
		if not need_to_reload:
			if GameSettings.reload_on_empty_clip:
				need_to_reload = true
				reload_gun()
		
	
#	HUD_node.emit_signal("gun_clip_ammo_changed", clip_size, ammo)
	
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
	
	

# Listen for changes in the clip and ammo values
func set_clip_size(new_value):
	clip_size = new_value
	HUD_node.emit_signal("gun_clip_ammo_changed", new_value, ammo)

func set_ammo(new_value):
	ammo = new_value
	HUD_node.emit_signal("gun_clip_ammo_changed", clip_size, new_value)


func get_bullet_info():
#	bullet_type = straight_bullet_1
	var bullet_with_info = bullet_type.instance()
	bullet_with_info.initialize() # This makes sure the bullets have their proper values before grabbing their data
#	add_child(bullet_with_info)
	
#	print("Info###########")
#	print(bullet_type)
#	print(bullet_with_info)
#	print("This already went")
	
	var bullet_info = {
		"damage_per_shot" : stepify(bullet_with_info.damage, 0.01),# * bullet_with_info.hit_points,
		"shots_per_second" : stepify(1 / primary_shot_debounce_time, 0.01),
		"hits_per_shot" : stepify(bullet_with_info.hit_points, 0.01)
	}
#	bullet_with_info.queue_free()
	
	return bullet_info
	



func _on_PrimaryShotDebounceTimer_timeout() -> void:
#	print($PrimaryShotDebounceTimer.wait_time)
#	print("debounce_timer_counter: " + str(debounce_timer_counter))
	debounce_timer_counter = 0
	start_count = false
	primary_shot_debounce = false

func _on_SecondaryShotDebounceTimer_timeout() -> void:
	secondary_shot_debounce = false

# When the time is done and the gun can have its reloaded clip
func _on_ReloadTimer_timeout() -> void:
	if ammo > 0 and clip_size < clip_max_size:
		var add_to_clip_amount = 0
		
		self.ammo -= clip_max_size
		print("Ammo: " + str(ammo))
		if ammo != clip_max_size:
			if ammo < 0:
				add_to_clip_amount = -1 * ammo
				self.ammo = 0
			elif ammo >= 0:#> 0:
				add_to_clip_amount = clip_max_size
#			elif ammo == 0: # Ammo was the same amount as the clip_max_size
#				add_to_clip_amount = clip_max_size
		else:
			add_to_clip_amount = clip_max_size
		
		clip_size = 0
		self.clip_size += add_to_clip_amount
		
		# Make sure the clip has some bullets before letting the player shoot again
		if clip_size > 0:
			need_to_reload = false
	



