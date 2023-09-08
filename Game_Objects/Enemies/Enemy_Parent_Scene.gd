extends KinematicBody2D

# MUST MAKE THIS A BASE ENEMY SCENE. CAN MAKE ANY CHANGES TO GENERAL THINGS ONCE, BUT AFFECTING ALL ENEMIES WITH THE CODE INHERITED. e.g., pathfinding, attack trigger

signal get_hit

# Ammo pickup scene
var ammo_pickup_scene = preload("res://Game_Objects/AmmoPickup.tscn")

var barricade_group_name = "barricade"

# Values
export var walk_speed = 200#150
export var hit_points = 30# setget hit_points_set, hit_points_get
var max_hp = hit_points

export var damage = 1#attack_damage = 1
var pierce = 0#attack_pierce = 0
var attack_range = 70
var attack_anim_speed = 1

var can_move = true
var knockback_enemy = false # For moving the enemy backward a moment
var knockback_enemy_stay_still = false
var bullet_knockback_strength = 100 # Pixels per second

# These have the purpose of making it so the enemy can knockback hard and fast then stay still for a moment
var knockback_counter = 0
const KNOCKBACK_COOLDOWN = (0.125 / 2) * 60 # In frames
const KNOCKBACK_STAY_STILL_COOLDOWN = 0.25 * 60 # In frames

var bullet_shot_velocity


# Other values intended for use with status effects, resistances, weaknesses, etc.
var armor = 0
var damage_effectors = {
	"weaknesses": {
		"fire": 0.5,
		"ice": 0.25
	},
	"strengths": {
		"pierce": 0.1, # The slime for example, doesn't have armor, but has resistance to piercing damage
		"explosion": 0.75
	}
}
var attack_effectors = {
	
}

# Then to access
# Getting the number 0.5 from the fire effector
#var test_effector = damage_effectors["weaknesses"][0][1] # I don't really like this way of doing it

#var weaknesses = []
#var resistances = []

# Value of monster (Amount of cash earned from defeating this monster)
var cash_value = 5

var acceleration = walk_speed - 50
var walk_velocity = Vector2.ZERO


var run_away = false

# Animation and states
var states = ["Idle", "Walking", "Attacking", "Pathfinding"]
var state = states[0]

var traversal_state_name = "Traverse_Path"
var pursuit_state_name = "Pursuit"
var moving_type = pursuit_state_name
var search_for_target = true

var change_attack_anim = true # Determines if the animation must change
var animation_player = null # For playing animations
var which_side = 0 # Attack animation changes based on which side is chosen at random (left or right side)
var which_anim = "" # Animation name is passed to the change_anim() method
var current_anim = ""

var target = null
export var path_change_time = 0.5
var previous_target
var point_to_move_to
var bit_mask = 0b100101

# For random number generation
var rng = RandomNumberGenerator.new()

# For scenes to be accessed
var enemy_spawner = null
var player_node
var navigation2d_agent
var line2D
var line2D_2

var scene_tree

# For pathfinding
var frames_counter = 0
var initialize_target_location_debounce = false

var points_in_line = [Vector2.ZERO, Vector2.ZERO]
#var points_in_line = PoolVector2Array()
#var points_in_line_2 = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

var dead = false
var chosen_barricade
var inside_arena

var melee_attacker = true
#var can_attack = true
var animation_interrupted = false

var attacking = false
var cast_ray_for_attack = false
var attack_can_hit = true


# Waits for the enemy scene to be ready
func _ready() -> void:
	# Testing the effectors
#	print("Effector test: " + str(test_effector))
	
#	var test_object = {
#		"weaknesses": {
#			"fire": 0.5,
#			"ice": 0.25
#		}
#	}
#	print("Testing other methods: " + str(test_object["weaknesses"]["fire"]))
#
#	print(test_object["weaknesses"].values())
#	for which_one in test_object:
#		for effector in test_object[which_one]:
#			print("Testing one more thing: " + str(effector) + ", value: " + str(test_object[which_one][effector]))
#
	
#	print(0b010101)
#	print(0b110101)
	
	scene_tree = get_tree()
#	print()
	player_node = get_node("../Player")
#	target = player_scene
	animation_player = get_node("AnimationPlayer")
	enemy_spawner = get_node("../MobSpawner")
	navigation2d_agent = get_node("NavigationAgent2D")
	
	line2D = get_node("Line2D")
	line2D.set_round_precision(2)
	line2D.set_width(4)
	
	line2D_2 = get_node("Line2D2")
	line2D_2.set_round_precision(2)
	line2D_2.set_width(2)
	
	rng.randomize()
	
	
#	# Randomize a variation to each spawned enemy
#	walk_speed = rng.randi_range(walk_speed - 75, walk_speed + 75)
	
	# Check for barricade and make it the target
	var new_target = choose_barricade_to_target()
	if new_target:
		change_target(new_target)
		chosen_barricade = new_target
	
	inside_arena = false
#	var test_r = rng.randi_range(0, 4)
#	if test_r > 2:
#		run_away = true


func randomize_walk_speed():
	# Randomize a variation to each spawned enemy
	walk_speed = rng.randi_range(walk_speed - 25, walk_speed + 25)


# Change animation based on animation name and set the speed multiplier
func change_anim(new_anim, speed):
#	if current_anim != new_anim:
	current_anim = new_anim
	animation_player.playback_speed = speed
	animation_player.play(current_anim)

func change_target(new_target):
	target = new_target
	previous_target = target


func trigger_attack_ray_cast():
	cast_ray_for_attack = true


# Main loop for the enemy
func _physics_process(delta: float) -> void:
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
#	if cast_ray_for_attack:
#		cast_ray_for_attack = false
#		cast_ray_to_verify_attack(space_state, target.global_position)
	
	# Pushes the enemy back when shot
	if knockback_enemy:
		knockback_counter += 1
		walk_velocity = bullet_shot_velocity.normalized() * bullet_knockback_strength
#		rotation = (player_node.position - global_position).angle() + deg2rad(-90)
		walk_velocity = move_and_slide(walk_velocity)# * delta
		if knockback_counter >= KNOCKBACK_COOLDOWN: # 0.25/second
			knockback_enemy = false
			knockback_enemy_stay_still = true
			knockback_counter = 0
	
	# Forces enemy to stop moving for a moment after being knocked back
	if knockback_enemy_stay_still:
		knockback_counter += 1
		walk_velocity = Vector2(0, 0)
		move_and_slide(walk_velocity)
		if knockback_counter >= KNOCKBACK_STAY_STILL_COOLDOWN:
			can_move = true
			knockback_enemy_stay_still = false
	
	if can_move:
		if cast_ray_for_attack:
			cast_ray_for_attack = false
			cast_ray_to_verify_attack(space_state, target.global_position)
	#		var distance_from_target = (target.global_position - global_position).length()
	#		print(self)
	#		print(target)
	##		print(distance_from_target)
	#		if distance_from_target > attack_range: # Player is now out of range
	#			attacking = false # Cancel attacking
	#		else:
	#			which_side = rng.randi_range(0, 1)
	#			which_anim = ""
	#
	#			change_attack_anim = true
		
	#	print(global_position)
	#	if target:
	##		if search_for_target:
	##			cast_ray_to_target(space_state, target.global_position)
	#
	#		if moving_type == traversal_state_name:
	#			point_to_move_to = navigation2d_agent.get_next_location()
	##			point_to_move_to = navigation2d_agent.get_nav_path()
	#			print(point_to_move_to)
		############################################################
		
		# Target exists
		if target:
	#		print("Why bro")
	#		if inside_arena == false:
	#			moving_type = pursuit_state_name
	#			change_target(chosen_barricade)
			
	#		print("Barricade down: " + str(chosen_barricade.barricade_down))
	#		if chosen_barricade.barricade_down == true:
	#			bit_mask = 0b010101
	#		else:
	#			bit_mask = 0b110101
				
			
	#		if target.is_in_group(barricade_group_name):
	#			if target.barricade_down == true and inside_arena == true: # Barricade down
	#				change_target(player_node)
			
	#		elif target == player_node:
	#			pass
	#			if chosen_barricade.barricade_down == false and inside_arena == false: # Barricade up
	##				print("Up")
	#				change_target(chosen_barricade)
	#		if target.is_in_group(barricade_group_name):
	#			# Check if the barricade is down
	#			if target.barricade_down and target != player_node:
	#				change_target(player_node)
	#			else:
	#				pass
	#				# Determine if the enemy is able to reach the player. Otherwise, attack the barricade
	#				#
	##				change_target(choose_barricade_to_target())
	#		else:
	#			change_target(choose_barricade_to_target())
			
	#		var direction_to_target = (target.position - global_position)
	#		var distance_from_target = direction_to_target.length()
			
	#		if run_away:
	#			direction_to_target = run_from_player(direction_to_target)
			
			var point_from_enemy_to_player = (player_node.position - global_position)
			var distance_from_player = point_from_enemy_to_player.length()
			
			var direction_to_barricade = (chosen_barricade.global_position - global_position)
			var distance_from_barricade = direction_to_barricade.length()
			
			# Need to make sure the enemy doesn't go to another barricade, so only target player when in attacking range
			# or when inside the arena
			if inside_arena == false: # Not inside arena
	#			if chosen_barricade.barricade_down == false: # Barricade is not down
	#				change_target(chosen_barricade)
	#			else: # Barricade is down
	##				change_target(player_node)
	#				pass
				if distance_from_barricade <= attack_range: # If enemy comes within distance of attacking the barricade
					if chosen_barricade.barricade_down: # If barricade is down
						change_target(player_node)
				
				if chosen_barricade.barricade_down == false:
					change_target(chosen_barricade)
			elif inside_arena == true:
				change_target(player_node)
				
			
			var direction_to_target = (target.position - global_position)
			var distance_from_target = direction_to_target.length()
			
			# Changes enemy state based on distance from target
			if distance_from_target <= attack_range:
				if inside_arena == false:
					if chosen_barricade.barricade_down == true:
						pass
	#					change_target(player_node)
	#					state = states[1] # Move
							
					elif chosen_barricade.barricade_down == false:
						change_target(chosen_barricade)
						state = states[2] # Attack
							
				else:
					attacking = true
					state = states[2] # Attack
					
	#			state = states[2] # Attack
	#			if chosen_barricade.barricade_down and inside_arena == false:
	#				state = states[1]
	#				change_target(player_node)
			else: # Out of attack range
	#			print("Attempting to move")
				var current_anim_name = animation_player.current_animation # Prevent the enemy from 
				if current_anim_name == "Walk" or current_anim_name == "":
					attacking = false
				if not attacking:
	#				print("State changed to move")
					state = states[1] # Move
				
			if search_for_target:
				cast_ray_to_target(space_state, target.global_position)
			
			# For changing animations based on current state
			if state == states[1]: # Moving
	#			if not melee_attacker:
				if not animation_player.get_current_animation() == "Walk":
					change_attack_anim = true
	#				if animation_player.get_current_animation_position() < animation_player.get_current_animation().length(): # If animation had not reached the end
	#					animation_interrupted = true
					change_anim("Walk", 1)
	#			else:
	#				if animation_player.get_current_animation_position() >= animation_player.get_current_animation().length():
	#					if not animation_player.get_current_animation() == "Walk":
	#						change_anim("Walk", 1)
			
				var normalized_dir = Vector2.ZERO
				
				# Change state between pursuing and traversing
				if moving_type == pursuit_state_name: # Pursuit (Walk straight to the target)
					initialize_target_location_debounce = false
					normalized_dir = direction_to_target.normalized()
				elif moving_type == traversal_state_name: # Traversal (Walk through the path to the target)
					# start pathfinding. First, find the path between the points
					if not initialize_target_location_debounce:
						initialize_target_location_debounce = true
	#					navigation2d_agent.set_navigation(get_node(".."))
	#					var nav_map = navigation2d_agent.get_navigation_map()
	#					print(nav_map.get_id())
						set_target_location(target.global_position)
						$ChangePathTimer.start(path_change_time)
					
	#				if frames_counter >= 30:
	#					frames_counter = 0
	#					set_target_location(target.global_position)
	#				else:
	#					frames_counter += 1
					
					point_to_move_to = navigation2d_agent.get_next_location()
	#				var path_exists = point_to_move_to
	#				if not point_to_move_to:
	#					change_target(choose_barricade_to_target())
					
					points_in_line[0] = Vector2(0, 0)#global_position
	#				points_in_line[1] = to_local(point_to_move_to)
					line2D.points = points_in_line#.set_points(points_in_line)
					
					var points_for_line = navigation2d_agent.get_nav_path()
					for i in range(points_for_line.size()):
	#					print("index: " + str(i))
						var old_vector2 = points_for_line[i]
						points_for_line.set(i, to_local(points_for_line[i]))

	#					points_for_line. = to_local(points_for_line[i])
					points_for_line.push_back(to_local(navigation2d_agent.get_final_location()))
	#				line2D_2.points = points_for_line
	#				print(navigation2d_agent.get_nav_path())
					
					if navigation2d_agent.is_navigation_finished():
						set_target_location(target.global_position)
					
					normalized_dir = (point_to_move_to - global_position).normalized()
				
	#			print(point_to_move_to)
				walk_velocity += normalized_dir * walk_speed
	#			navigation2d_agent.set_velocity(walk_velocity)
				
				
				rotation = walk_velocity.angle() + deg2rad(-90)
				
#				if knockback_enemy:
##					print(bullet_shot_velocity)
#					walk_velocity = bullet_shot_velocity.normalized() * knockback_strength
#					print(walk_velocity)
				
				walk_velocity = move_and_slide(walk_velocity.clamped(walk_speed))# * delta
	#			position += walk_velocity
	#			print(walk_velocity)
	#			print("Why--------------------------------------moving")
			elif state == states[2]: # Attacking
				if melee_attacker:
					if change_attack_anim:
		#				attacking = true
						
						which_side = rng.randi_range(0, 1)
						which_anim = ""
					
						if which_side == 0:
							which_anim = "Attack_left"
						elif which_side == 1:
							which_anim = "Attack_right"
						
						change_anim(which_anim, rng.randf_range(1.25, 1.5))
						change_attack_anim = false
	#			else:
	#				if can_attack:
	#					change_anim("Attack", 1.5)
	#			print("Attacking ---------------------------------")
				# This allows the enemy to stop moving, but still detect collision (On its end, KinematicBody2D methods)
				# *** Might not need this ***
				walk_velocity = Vector2.ZERO
				walk_velocity = move_and_slide(walk_velocity)
				
				rotation = direction_to_target.angle() + deg2rad(-90)
		
		
		
		
#	else: # If target no longer exists, or never existed
#		if previous_target != player_node:
#			change_target(player_node)
	


#func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2) -> void:
##	print("ksjdlrf;kajseo;fijswa;oeiksekeiifn")
#	points_in_line[1] = points_in_line[0] + to_local(safe_velocity)
#	walk_velocity = safe_velocity

#func _on_NavigationAgent2D_path_changed() -> void:
#	print("Path changed")

#func anim_finished():
#	print("Test")
#	if anim_name != "Walk": # Enemy just finished attack animation
#		attack_can_hit = false
#		cast_ray_for_attack = true

# Check if the enemy's attack animation has finished, then play the next randomized attack animation
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print("Test")
	if anim_name != "Walk": # Enemy just finished attack animation
		pass
#		attack_can_hit = false
#		cast_ray_for_attack = true
		var distance_from_target = (target.global_position - global_position).length()
#		print(distance_from_target)
		if distance_from_target > attack_range: # Player is now out of range
			print("Attack cancelled!!!!")
			attacking = false # Cancel attacking
		else:
			which_side = rng.randi_range(0, 1)
			which_anim = ""

			change_attack_anim = true
	if anim_name == "flinch":
		pass
		# Make sure to allow the enemy to do everything again
#		knockback_enemy = false
#		# Reset the enemy's velocity so it doesn't reach (0, 0), to prevent it from jittering after flinch
#		walk_velocity = (player_node.position - global_position).normalized()
#		can_move = true





## Mostly using this for raycasting and drawing the resulting lines for debugging
#func _physics_process(delta: float) -> void:
#	var space_rid = get_world_2d().space
#	var space_state = Physics2DServer.space_get_direct_state(space_rid)
#
#	if target:
#		if search_for_target:
#			cast_ray_to_target(space_state, target.global_position)
#
#		if moving_type == traversal_state_name:
#			point_to_move_to = navigation2d_agent.get_next_location()
##			point_to_move_to = navigation2d_agent.get_nav_path()
#			print(point_to_move_to)

# ------------------------------------------------------------------------
# Enemy navigation and traversing
# ------------------------------------------------------------------------

# This portion will be used for checking for clear paths to the target, determining if the enemy should travel directly toward the target or activate pathfinding

func set_target_location(target_pos):
	navigation2d_agent.set_target_location(target_pos)
	
#	navigation2d_agent.get_nav_path()

func direction_to_next_point():
	pass
	

#func result_cast_ray_to_target(space_state, target_pos):
#	var result = space_state.intersect_ray(self.global_position, target.global_position, [self], bit_mask)
#	if result:
#		# Check if result is the player
#		if result.collider:
#			if result.collider.get_collision_layer_bit(0): # If ray hits player

func cast_ray_to_verify_attack(space_state, target_pos):
	var vector_from_attack_range = (target_pos - self.global_position).normalized() * attack_range
	var vector_add_attack_range = self.global_position + vector_from_attack_range
	
	print(vector_from_attack_range)
	print(vector_add_attack_range)
	
	var result = space_state.intersect_ray(self.global_position, vector_add_attack_range, [self], bit_mask)
	
	if result:
		if result.collider:
			print("Collider name")
			print(result.collider.name)
			if result.collider == target: # Hit player
				attack_target()
				pass
	else:
		print("Nothing hit.")

func cast_ray_to_target(space_state, target_pos):
	var result = space_state.intersect_ray(self.global_position, target.global_position, [self], bit_mask)
	if result:
		
#		print(result.)
		# Draw the line to the resulting point
#		points_in_line[0] = Vector2(0, 0)#global_position
#		points_in_line[1] = to_local(result.position)#Vector2(0, 200)
#		line2D.points = points_in_line#.set_points(points_in_line)
		
#			points_in_line.push_back(points_in_line[points_in_line.size()-2] + Vector2(2, 1))
		
		# Check if result is the player
		if result.collider:
			if result.collider.get_collision_layer_bit(0): # If ray hits player
				moving_type = pursuit_state_name
				
			elif result.collider.is_in_group(barricade_group_name) and target.is_in_group(barricade_group_name):
				pass
#				moving_type = pursuit_state_name
#				change_target(chosen_barricade)
#				# Try changing it to previous_target once things are proven to work
##				if target == player_node and result.collider.barricade_down == false:
##					change_target(choose_barricade_to_target())
##				elif target == result.collider and result.collider.barricade_down == true:
##					change_target(player_node)
#				if result.collider.barricade_down == false:
#					moving_type = pursuit_state_name
#				if target == player_node:
#					change_target(chosen_barricade)
			else:
#				print("target is: " + str(target))
				state = states[1]
				moving_type = traversal_state_name



func run_from_player(dir_to_target):
	$Body.modulate = Color(0.15, 0.15, 1, 1)
	return -dir_to_target


func choose_barricade_to_target():
	var barricades = scene_tree.get_nodes_in_group("barricade")
	
	# Get the 2 closest barricades and randomly decide which one the enemy should target
	if len(barricades) > 0: # If any barricades exist
		var closest_barricade
		var shortest_distance
		
		for barricade in barricades:
			var distance = (barricade.position - position).length()
			
			if not shortest_distance:
				closest_barricade = barricade
				shortest_distance = distance
			else:
				if distance < shortest_distance:
					closest_barricade = barricade
					shortest_distance = distance
		return closest_barricade
		
# ------------------------------------------------------------------------
# Enemy hit detection and other collision resolves 
# ------------------------------------------------------------------------

# This function is called through the animation player via a function event in the animation
func attack_target():
	pass
#	print("Attacked")
	# Cast a ray to the target. If missed, return and continue as normal. If hit, emit signal to player of hit & damage

	if target: # Currently no raycasting involved
		target.emit_signal("get_hit", self)#attack_damage, attack_pierce)


# Deal with the enemy being hit
func has_been_hit(bullet):
	print(bullet.pierce)
	var new_armor = armor - bullet.pierce
	var new_damage = (bullet.damage - (armor - (bullet.pierce * sign(armor))))
	
	if new_damage > bullet.damage: # Prevent damage becoming more than the original damage
		new_damage = bullet.damage
	if new_damage < 0: # Prevent attacks from healing enemies (because enemy_hp = enemy_hp - damage, if damage < 0, e.g., dmg = 1; dmg = dmg - (-1).)
		new_damage = 0
	print("damage: " + str(bullet.damage))
	print("new damage: " + str(new_damage))
	print("Enemy hp BEFORE damage: " + str(hit_points))
	self.hit_points -= new_damage
	print("Enemy hp AFTER damage: " + str(hit_points))
	
	# 0 hp (death)
	if self.hit_points <= 0:
		on_enemy_death()
		# For debugging/testing: Spawns an enemy when another enemy dies
#		if enemy_spawner.spawn_on_enemy_death:
#			enemy_spawner.spawn_enemy()
	
	animation_player.stop()
	animation_player.play("flinch")
	
	can_move = false
	
	# For knocking back enemies
	knockback_enemy = true
	knockback_counter = 0
	bullet_knockback_strength = bullet.knockback_strength
	
#	print((30.0 / 100.0) * max_hp)
	if self.hit_points <= (30.0 / 100.0) * max_hp:
		run_away = true


# Enemy hit by player
func _on_Enemy_get_hit(bullet) -> void:
#	print("Hit with damage: " + str(damage))
	bullet_shot_velocity = bullet.velocity
	has_been_hit(bullet)


# Enemy death
func on_enemy_death():
	# Play death animation and set timer to eliminate the dead body
#	set_process(false)
	set_physics_process(false)
	animation_player.play("RESET")
	$Body.modulate = Color(1, 0.1, 0.25, 1)
	$Body.z_index = -1
	$CollisionShape2D.set_deferred("disabled", true)
	# animation_play()
	$RemoveDeadBodyTimer.start()
	
	# Reward the player with cash
	if player_node:
		if not dead:
			dead = true
			player_node.emit_signal("earn_cash", cash_value)
	
	var dice_roll_number = rng.randi_range(1, 6)
	if dice_roll_number == 3 or dice_roll_number == 5 or dice_roll_number == 1:# or dice_roll_number == 4:
		# Spawn an ammo pickup
		var ammo_pickup_instance = ammo_pickup_scene.instance()
		ammo_pickup_instance.global_position = global_position
		get_node("..").add_child(ammo_pickup_instance)
	


# Removes the enemy body
func _on_RemoveDeadBodyTimer_timeout() -> void:
	queue_free()
	

# Update the pathfinding if the enemy's state is traversal
func _on_ChangePathTimer_timeout() -> void:
	if moving_type == traversal_state_name: # Enemy is making use of pathfinding
		set_target_location(target.global_position) # Update the target location (Recompute path to target)
		$ChangePathTimer.start(path_change_time)


# Literally fires when the path changes. Nothing special here for information
func _on_NavigationAgent2D_path_changed() -> void:
	pass
#	print("Path changed")
#	print("Path changed")








#	check_for_collisions()

# Detecting collisions via slide_collision from KinematicBody2D
#func check_for_collisions():
#	var amount_of_collisions = get_slide_count()
#
#	for i in amount_of_collisions:
#		var instance_id = get_slide_collision(i).collider_id
##		print(instance_id)
#		var collided_bullet = instance_from_id(instance_id)
#
#		collided_bullet.get_node("CollisionShape2D").set("disabled", true)
#		collided_bullet.queue_free()
#
#		self.hit_points -= collided_bullet.damage
		


## For detecting changes in the enemy's hit_points
#func hit_points_set(new_value):
#	print("new hit_points value: " + str(new_value))
#	hit_points = new_value
#	emit_signal("has_been_hit", hit_points)
#
#func hit_points_get():
#	print("hit_points: " + str(hit_points))
#	return hit_points












