extends KinematicBody2D


# Custom signals
signal get_hit
signal earn_cash
signal barricade_popup



var viewport
var screen_size
var draw_node

# Player variables
export var walk_speed = 25 #pixels per second
var mouse_position = Vector2.ZERO
var move_velocity = Vector2.ZERO

# For in-game character
export var extra_lives = 3
export var max_hp = 50
export var hit_points = 50 setget set_hp, get_hp
var cash = 100 setget set_cash, get_cash


var currently_equipped_gun
var owned_weapons


#var shot_debounce = false
var rng = RandomNumberGenerator.new()

var gun = null
var camera = null
export var camera_zoom = Vector2(1.5, 1.5)
var camera_pan_speed = 20
var screen_margin_size = 0.15

var point_from_gun_to_mouse = Vector2.ZERO

var can_fix_barricade = false
var in_range_of_barricade = false
var which_barricade

# Load SCENES
var HUD_node
var guns_handler_node
var shop_menu_node

var scene_tree

# Setting up its weaknesses & strengths
var armor = 0
var damage_effectors = {
		"weaknesses": {
			
		},
		"strengths": {
			
		}
	}

# Array with a list of the currently applied effects on the player
var active_effectors = []




func _ready() -> void:
	scene_tree = get_tree()
	screen_size = Vector2.ZERO
	viewport = get_viewport()
#	OS.window_size = Vector2(1020, 1020)
#	viewport.size = Vector2(500,500)
#	screen_size = viewport.size
	draw_node = get_node("../Draw")
	
	gun = get_node("Gun")
	camera = get_node("../../Camera2D")
#	viewport = camera.get_custom_viewport()
	
	HUD_node = get_node("../HUD")
	guns_handler_node = get_node("../GunsHandler")
	shop_menu_node = HUD_node.get_node("PauseMenu/ShopMenu")
	
	# Connect the _ready signal of HUD to _on_HUD_ready()
	HUD_node.connect("ready", self, "_on_HUD_ready")
	
	rng.randomize()
	
	camera.zoom = camera_zoom
	camera.position = position
	
#	set_process(true)
	set_physics_process(true)
	

#func _input(event):
#   # Mouse in viewport coordinates.
#   if event is InputEventMouseButton:
#	   print("Mouse Click/Unclick at: ", event.position)
#   elif event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)

func get_barricade_in_range():
	var barricades = scene_tree.get_nodes_in_group("barricade")
	var old_closest_distance = null
	var trigger_range = 150
	
	if len(barricades) > 0: # If any barricades exist
		for barricade in barricades:
			var distance = (barricade.position - position).length()
			
			if distance <= trigger_range:
				return barricade
	

#func is_close_to_barricade():
#	var barricades = scene_tree.get_nodes_in_group("barricade")
#	var old_closest_distance = null
#	var trigger_range = 100
#
#
#	if len(barricades) > 0:
#		for barricade in barricades: # Problem was this: The for loop went through all of the barricades, regardless if one was in range, causing the last barricade in the array to be chosen. (That prevented the player from fixing the other barricades. Added a break in the loop after finding one in-range.)
#			var distance = (barricade.position - position).length()
#
#			if distance <= trigger_range:
#				if not in_range_of_barricade:
#					in_range_of_barricade = true
#					can_fix_barricade = true
##					print("Press f to fix barricade")
#					which_barricade = barricade
#					break
#			elif distance > trigger_range:
#				if in_range_of_barricade:
#					in_range_of_barricade = false
#					can_fix_barricade = false
#					which_barricade = null
#			if not old_closest_distance:
#				old_closest_distance = distance
#			else:
#				if distance < old_closest_distance:
#					old_closest_distance = distance


func _physics_process(delta: float) -> void:
#	viewport = get_viewport()
	
	var move_direction = Vector2.ZERO
	mouse_position = get_global_mouse_position()#viewport.get_mouse_position()
#
	var look_direction = mouse_position - global_position
	
#	print(position)
#	print(mouse_position)
#	var look_dir_length = look_direction.length()
	look_direction = atan2(look_direction.y, look_direction.x)
#
#	var gun_point_to_mouse = mouse_position - gun.global_position
#	point_from_gun_to_mouse = gun_point_to_mouse
#	var gun_point_to_mouse_length = gun_point_to_mouse.length()
#	gun_point_to_mouse = atan2(gun_point_to_mouse.y, gun_point_to_mouse.x)
	
	
	
	
	# Gets input from the player and stores the corresponding keys as integer values converted from bools
	var left_key = int(Input.is_action_pressed("move_left"))
	var right_key = int(Input.is_action_pressed("move_right"))
	var up_key = int(Input.is_action_pressed("move_up"))
	var down_key = int(Input.is_action_pressed("move_down"))
	
	var restart_key = Input.is_action_just_pressed("restart")
	if restart_key:
#		print("Restart")
#		get_tree().reload_current_scene()
#		scene_tree.change_scene("res://Game_Objects/Menus/MainMenu.tscn/")
		pass
	
	# Shoot gun
#	if gun.is_held:
#		gun.emit_signal("shoot", look_direction, point_from_gun_to_mouse)
	
	
	var barricade = get_barricade_in_range()
	
	if barricade:
		if barricade.hit_points < barricade.max_hp:
#			print("Press f to fix barricade")
			
			HUD_node.action_indicator_label.visible = true
			if Input.is_action_just_pressed("fix_barricade"):
				barricade.hit_points = barricade.max_hp
		elif barricade.hit_points > 0:
			HUD_node.action_indicator_label.visible = false
	else:
		HUD_node.action_indicator_label.visible = false
		
			
	
#	# For fixing barricades
#	is_close_to_barricade()
#
#	if can_fix_barricade:
#		if which_barricade:
##			print("Test")
#			if which_barricade.hit_points < which_barricade.max_hp:
#				print("Press f to fix barricade")
#				if Input.is_action_just_pressed("fix_barricade"):
#					which_barricade.hit_points = which_barricade.max_hp
					
	
	
	
	
	
	# Right-click for debugging
#	if Input.is_mouse_button_pressed(2):
#		print("Separate!!! -----------------------------------------------")
	
#	left_key = int(left_key)
#	right_key = int(right_key)
#	up_key = int(up_key)
#	down_key = int(down_key)
	
	var h_dir = right_key - left_key
	var v_dir = down_key - up_key
	
	
#	print(h_dir)
#	print(v_dir)
	
	# Camera control
#	var bottom_right_margin = camera.get("")
#	print(bottom_right_margin)
	
	var camera_move_amount = Vector2(0, 0)#(viewport.get_mouse_position() - viewport.size/2).normalized() * 5
	
#	var camera_canvas_item = camera.get_node("$CanvasItem")
#	print(camera_canvas_item)
	
	#viewport.size.x / 2 * 1.5
	var screen_size = Vector2(viewport.get_size_override().x, viewport.get_size_override().y) * camera.zoom.x
	var how_far_xr = 0
	var how_far_yr = 0
	
	var reference_point = camera.get_camera_screen_center() # Center of camera
	
	var screen_margin = Vector2(screen_size.y * screen_margin_size, screen_size.y * screen_margin_size) * camera.zoom
	
	# ----------------------------------- Controlling the camera with the mouse -------------------------------------
	# Determines the amount the camera should move
	
	# Right side
	if mouse_position.x > reference_point.x + screen_size.x/2 - screen_margin.x:# + (viewport.size.x / 9.5):
		how_far_xr = mouse_position.x - (reference_point.x + screen_size.x/2 - screen_margin.x)
		camera_move_amount.x = how_far_xr / screen_margin.x * camera_pan_speed
	
	# Left side
	if mouse_position.x < reference_point.x - screen_size.x/2 + screen_margin.x:
		how_far_xr = mouse_position.x - (reference_point.x - screen_size.x/2 + screen_margin.x)
		camera_move_amount.x = how_far_xr / screen_margin.x * camera_pan_speed
	
	# Down side
	if mouse_position.y > reference_point.y + screen_size.y/2 - screen_margin.y:
		how_far_yr = mouse_position.y - (reference_point.y + screen_size.y/2 - screen_margin.y)
		camera_move_amount.y = how_far_yr / screen_margin.y * camera_pan_speed
		
	# Up side
	if mouse_position.y < reference_point.y - screen_size.y/2 + screen_margin.y:
		how_far_yr = mouse_position.y - (reference_point.y - screen_size.y/2 + screen_margin.y)
		camera_move_amount.y = how_far_yr / screen_margin.y * camera_pan_speed
	
	
	
	
	
#	camera.global_position.x += camera_move_amount.x
#	camera.global_position.y += camera_move_amount.y
	
	# Normalize the movement vector
	move_direction = Vector2(h_dir, v_dir).normalized()
	
	# Update the player's position
	move_velocity = move_direction * walk_speed# * delta
	
	# Update player and camera position
	move_velocity = move_and_slide(move_velocity)
	camera.global_position.x += camera_move_amount.x
	camera.global_position.y += camera_move_amount.y
	
	
	# ------------------------------------------------- Camera clipping -------------------------------------------------
	# Preventing the camera from going passed the player (Keeping the player on-screen)

	
	# Making sure to use the camera's global position as reference for the middle of the screen instead of camera.get_camera_screen_center()
	var left_side = camera.global_position.x - screen_size.x/2 + screen_margin.x
	var right_side = camera.global_position.x + screen_size.x/2 - screen_margin.x
	var up_side = camera.global_position.y - screen_size.y/2 + screen_margin.y
	var down_side = camera.global_position.y + screen_size.y/2 - screen_margin.y
	
	# If the player is going to move beyond the corner, move the camera so the player is still in view
	# Left
	if position.x < left_side:
		var distance_from_player = position.x - left_side
		camera.global_position.x += distance_from_player
	
	# Right
	if position.x > right_side:
		var distance_from_player = position.x - right_side
		camera.global_position.x += distance_from_player
	
	# Top
	if position.y < up_side:
		var distance_from_player = position.y - up_side
		camera.global_position.y += distance_from_player
		
	# Bottom
	if position.y > down_side:
		var distance_from_player = position.y - down_side
		camera.global_position.y += distance_from_player
	
	
	rotation = look_direction - deg2rad(90)
	
	# Emit signal for drawing a line from the player to the mouse
#	draw_node.emit_signal("draw_from_player_to_mouse", reference_point + screen_size/2, mouse_position)# position, mouse_position)#gun_muzzle.global_position, mouse_position)





# Player values changed ----------------------------------------------------------------------------

# Player earns a cash reward
func _on_Player_earn_cash(cash_reward):
	self.cash += cash_reward

# Set the player's cash
func set_cash(new_value):
	cash = new_value
	if HUD_node:
		HUD_node.emit_signal("player_cash_changed", cash)
	
	if shop_menu_node:
		shop_menu_node.emit_signal("player_cash_changed", cash)
	

# Detect changes in the player's hp
func get_cash():
	return cash


# Set the player's hp
func set_hp(new_value):
	hit_points = new_value
	if HUD_node:
		HUD_node.emit_signal("player_hp_changed", hit_points)
	

# Detect changes in the player's hp
func get_hp():
	return hit_points



# When the HUD is ready
func _on_HUD_ready():
	print("Ready from player")
	HUD_node.emit_signal("initialize_player", hit_points, max_hp, cash)
	
	



# ------------------------------------------------------------------------
# Player hit detection and damage
# ------------------------------------------------------------------------

# Player dies
func on_death():
	print("Player is dead")
	
	# Stop the player from moving, change the color and prompt the player that they died
	set_physics_process(false)
	$Body.modulate = Color(1, 0.1, 0.25, 1)
	
#	for gun in guns_handler_node.weapons_owned:
#		gun.set_physics_process(false)

	# There was a problem before that caused the script to error due to trying to retrieve the gun from the player
	# node by its name, via: get_node("Gun"). Now checking for the correct gun in the player node by searching
	# the group, "guns".
	var gun_equipped_from_gun_group
	for gun in scene_tree.get_nodes_in_group("guns"):
		if gun.get_parent() == self:
			gun_equipped_from_gun_group = gun
	
	
	
	gun_equipped_from_gun_group.set_process(false)
	guns_handler_node.set_physics_process(false)
	


# Player gets hit
func _on_Player_get_hit(damage, pierce) -> void:
	# Remove health from the player, based on how much damage was dealt
	self.hit_points -= damage
	print("Player hp: " + str(hit_points))
	if hit_points <= 0:
		on_death()
	









