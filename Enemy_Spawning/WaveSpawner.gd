extends Node

# This node is responsible for controlling wave spawning. This includes displaying current wave to the player, spawning enemies via sub waves

var slime_enemy_name = "slime"
var fast_slime_enemy_name = "fast_slime" # Not available for the current time
var rock_enemy_name = "rock_monster"
var spitter_enemy_name = "spitter"

# For pre-determined wave spawning
var waves = [
	[ # wave 1 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				#[spitter_enemy_name, 1],
				[slime_enemy_name, 3],
				#[rock_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 3 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 2,
			"enemy_types": [
				[slime_enemy_name, 3],
				#[rock_enemy_name, 2],
#				[spitter_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 1 #(seconds)
		},
	],
	
	[ # wave 2 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				[slime_enemy_name, 5],
#				[rock_enemy_name, 4]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 1 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 3,
			"enemy_types": [
				[slime_enemy_name, 3],
#				[rock_enemy_name, 5]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 2 #(seconds)
		},
	],
	
	[ # wave 3 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				[slime_enemy_name, 3],
#				[rock_enemy_name, 42]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 0.25 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 3,
			"enemy_types": [
				[slime_enemy_name, 10],
#				[rock_enemy_name, 55]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 2 #(seconds)
		},
		{ # sub-wave 3
			"pre_delay": 3,
			"enemy_types": [
				[slime_enemy_name, 2],
				[rock_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 4 #(seconds)
		},
	],
	
	[ # wave 1 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				#[spitter_enemy_name, 1],
				[slime_enemy_name, 3],
				#[rock_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 3 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 2,
			"enemy_types": [
				[slime_enemy_name, 3],
				#[rock_enemy_name, 2],
#				[spitter_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 1 #(seconds)
		},
	],
	
	[ # wave 4 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				#[spitter_enemy_name, 1],
				[slime_enemy_name, 3],
				#[rock_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 3 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 2,
			"enemy_types": [
				[slime_enemy_name, 3],
				#[rock_enemy_name, 2],
#				[spitter_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 1 #(seconds)
		},
	],
	
	[ # wave 5 ------------------------------------------------------------------------------------------
		{ # sub-wave 1
			"pre_delay": 3,
			"enemy_types": [
				#[spitter_enemy_name, 1],
				[slime_enemy_name, 3],
				#[rock_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 3 #(seconds)
		},
		{ # sub-wave 2
			"pre_delay": 2,
			"enemy_types": [
				[slime_enemy_name, 5],
				#[rock_enemy_name, 2],
#				[spitter_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 1 #(seconds)
		},
		{ # sub-wave 3
			"pre_delay": 4,
			"enemy_types": [
				[slime_enemy_name, 2],
				[rock_enemy_name, 2],
#				[spitter_enemy_name, 1]
			],
			# Introducing a new feature: one-by-one spawning! With this boolean enabled, the sub-wave will spawn an enemy from each type until there's none left in the sub-wave!
			#one_by_one = false
			"spawn_rate": 0.5 #(seconds)
		},
	],
	# Add more waves here ----------------
]

# ------------------------------------------------------------------------------------------------------------------------------



# Example of accessing the wave's data
# waves[current_wave-1][current_sub_wave-1].pre_delay

var current_wave = 0 setget set_wave_number, get_wave_number
var current_sub_wave = 0
var current_sub_wave_index = 0
# Either I can do this to keep track of which waves & sub-waves I'm currently on, or I can determine that through a duplicate table.
# This would work by eliminating each object as they are used in order from first to last, top to bottom

var wave_complete = false
var enemies_remaining = 0


var viewport = null
var enemies_group_name = "enemies"

# Essential scenes (Mostly enemy scenes)
var enemy_slime_scene = preload("res://Game_Objects/Enemies/Slime_Monster.tscn")
var enemy_rock_scene = preload("res://Game_Objects/Enemies/Rock_Monster.tscn")
var enemy_spitter_scene = preload("res://Game_Objects/Enemies/Spitter_Monster.tscn")

# For spawning
var this_scene_tree
var rng = RandomNumberGenerator.new()

# Spawn points
var spawn_points = []
var spawn_points_node

var HUD_node
var is_HUD_ready = false


var test_counter = 0
#var spawn_on_enemy_death = false
var arena_node

var player_node

var start_next_wave_timer
var show_player_wave_ended_animation




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(waves)
	
	rng.randomize()
	viewport = get_viewport()
	this_scene_tree = get_tree()
	
	spawn_points_node = get_node("../SpawnPoints")
	
	# Get the spawn positions
	spawn_points = spawn_points_node.get_children()
	
#	if is_HUD_ready:
#	print("Somthing's wrong if this doesn't print")
#	print(waves[current_wave-1][current_sub_wave-1].pre_delay)
	arena_node = get_node("..")#get_node("res://Game_Objects/Maps/Arena1.tscn")
	start_waves(1, 1)
	
	HUD_node = get_node("../HUD")
	HUD_node.connect("ready", self, "_on_HUD_ready")
	player_node = get_node("../Player")
	show_player_wave_ended_animation = HUD_node.get_node("HUDControl/WaveNumLabel/WaveFinishedLabel/AnimationPlayer").get_animation("Wave_Transition_Animation")
	
	start_next_wave_timer = $StartNextWaveTimer
	
#	set_process(false)
#	print(waves)
#	print(waves[0])
#	print(waves[0][0])
#	print(waves[0][0]["enemy_types"])
#	print(waves[0][0].enemy_types)
	

# HUD is ready
func _on_HUD_ready():
	is_HUD_ready = true
	HUD_node.emit_signal("initialize_wave_number", current_wave)

# Loop
func _process(delta):
# For testing: Idle process
#	if test_counter >= 30:
#		test_counter = 0
#		self.current_wave += 1
#	else:
#		test_counter += 1
	
	if wave_complete:
		enemies_remaining = this_scene_tree.get_nodes_in_group(enemies_group_name)
		if enemies_remaining.size() <= 0:
			# Now play the animation to show the player the next wave is starting
			HUD_node.emit_signal("inform_player_of_wave_ending", current_wave+1)
			# Now set timer to start next wave
			start_next_wave_timer.start(show_player_wave_ended_animation.length)
			start_next_wave()
			
#	print(enemies_remaining)


# For when the player triggers the start of the game
func start_waves(wave_number, sub_waves):
	current_wave = wave_number # Might not be necessary
	current_sub_wave = sub_waves
	# Start the timer for WaveStartDelayTimer for the first wave
#	print(waves[current_wave-1][current_sub_wave-1].pre_delay)
	$WaveStartDelayTimer.start(waves[current_wave-1][current_sub_wave-1].pre_delay)
#	print(waves[0][0].pre_delay)

# For starting each wave
func start_next_wave():
	player_node.hit_points = player_node.max_hp
	self.current_wave += 1
#	$WaveStartDelayTimer.start(waves[current_wave-1][current_sub_wave-1].pre_delay) #Basically triggers the next wave spawning loop
	wave_complete = false
#	print("ese: " + str(current_sub_wave) + ", " + str(current_sub_wave_index))

# Go to the next wave (Waits for all enemies to be destroyed before moving on
func next_wave():
	print("POISDIFSD")
	current_sub_wave_index = 0
	current_sub_wave = 1
	
	# If there is no other wave to move on to, end the game. The player has won.
	if current_wave <= waves.size()-1:
		print("Wave complete. Moving on to the next wave")
		wave_complete = true
		# Now wait for the player to finish off all of the enemies before starting the next wave
	else: # No other wave exists. End game
		issue_game_over("Waves complete")

# Goes to the next sub wave
func next_sub_wave():
	current_sub_wave_index = 0
	
	# Same principle as moving on to the next sub-wave, but moving on to the next wave when there are no more sub-waves
	if current_sub_wave <= waves[current_wave-1].size()-1: # If next sub-wave exists
		current_sub_wave += 1
#		print("test value: " + str(waves[current_wave-1].size()-1))
		print("Sub-wave complete. Moving to the next sub-wave.")
		# Start delay for the beginning of the next sub-wave
		$WaveStartDelayTimer.start(waves[current_wave-1][current_sub_wave-1].pre_delay)
	else: # No other sub-wave exists.
		next_wave()


# Returns name of enemy to spawn next
func get_which_enemy_to_spawn():
	var enemy_types = waves[current_wave-1][current_sub_wave-1].enemy_types # Get the sub-wave enemy types array
	var enemy_name# first index, 0, contains the enemy name
	
	if enemy_types[current_sub_wave_index][1] <= 0: # No more enemies of this type to spawn. Move to next type
		current_sub_wave_index += 1
		
	# Used to be: if enemy_types[current_sub_wave_index]:
	if current_sub_wave_index <= enemy_types.size()-1: # If there is an existing enemy in current_sub_wave_index
		enemy_types[current_sub_wave_index][1] -= 1 # enemy has been spawned. take away amount to spawn
		enemy_name = enemy_types[current_sub_wave_index][0] # Get name for returning to spawn function
		$SpawnTimer.start(waves[current_wave-1][current_sub_wave-1].spawn_rate)
#		if not current_sub_wave_index + 1 > enemy_types.size()-1:
#			$SpawnTimer.start(waves[current_wave-1][current_sub_wave-1].spawn_rate)
	else:
		next_sub_wave()
#		if current_sub_wave_index > enemy_types.size()-1:
#			next_sub_wave()
#		else:
#			$SpawnTimer.start(waves[current_wave-1][current_sub_wave-1].spawn_rate)
#	if current_sub_wave_index > enemy_types.size()-1: # If no other enemy exists on current_sub_wave_index, move on to the next sub-wave
#		next_sub_wave()
#	elif enemy_types[current_sub_wave_index][1] > 0: # If current sub-wave index amount of enemies is more than 0
#		enemy_types[current_sub_wave_index][1] -= 1
	
	return enemy_name
	
	

# Determine which random spawn point to use, then instantiate the chosen enemy from the current sub-wave to spawn
func spawn_enemy():
	var enemy_types = waves[current_wave-1][current_sub_wave-1].enemy_types
	var spawn_pos = Vector2.ZERO
	var rand_spawn_pos = rng.randi_range(1, spawn_points.size())
	
	# Choose the position of the given Position2D node from the index of the array
	spawn_pos = spawn_points[rand_spawn_pos-1].position
	
	
	var which_enemy_name = get_which_enemy_to_spawn()
	
	
	
	
	# Only actually spawn an enemy if a name has been returned
	if which_enemy_name:
		var spawn_enemy = true
		var which_enemy_scene
		var mob_instance
		
		if which_enemy_name == slime_enemy_name: # Slime monster
			which_enemy_scene = enemy_slime_scene
		elif which_enemy_name == rock_enemy_name: # Rock monster
			which_enemy_scene = enemy_rock_scene
		elif which_enemy_name == spitter_enemy_name: # Spitter monster
			which_enemy_scene = enemy_spitter_scene
		else:
			spawn_enemy = false
		
		
		
#		if which_enemy_name == slime_enemy_name:
#			pass
##		elif which_enemy_name == fast_enemy_name:
##			mob_instance.get_node("Body").modulate = Color(0.035, 0.63, 0.45)
##			mob_instance.walk_speed += rng.randf_range(3, 10)
#		else:
#			spawn_enemy = false
		
		if spawn_enemy:
			mob_instance = which_enemy_scene.instance()
			mob_instance.position = spawn_pos
			mob_instance.add_to_group(enemies_group_name)
		
		arena_node.add_child(mob_instance) # Add enemy to arena node
		print("Spawned enemy of type: " + str(which_enemy_name) + " at the coordinates: " + str(mob_instance.global_position))
	
#	if which_enemy_name:
#		# Start spawn timer again
#		$SpawnTimer.start(waves[current_wave-1][current_sub_wave-1].spawn_rate)
	# Now decide which enemy to spawn
	# Need to check which enemy to spawn based on list in current sub-wave
#	var enemy_type = ""
#	var change_in_speed = 0
#	var mob_instance
	# need to check the table on the current wave and current sub-wave and which enemy is next, eliminating it from the table after use
#	for key in waves[current_wave-1][current_sub_wave-1].enemy_types:
#		var value = waves[current_wave-1][current_sub_wave-1].enemy_types[key]
#		for i in value:
#			if value > 0:
#				if key == "common":
#					change_in_speed = 0
#				elif key == "fast":
#					change_in_speed = 10
#				value -= 1
#				mob_instance = enemy_common_scene.instance()
#				mob_instance.position = spawn_pos
#				mob_instance.add_to_group(enemies_group_name)
#				get_parent().add_child(mob_instance)
#			else:
#				break
			
#		print("The key is: " + key + ". The value is: " + str(value))
	
	
#	var mob_instance = enemy_common_scene.instance()
#	mob_instance.position = spawn_pos
#	mob_instance.add_to_group(enemies_group_name)
#	get_parent().add_child(mob_instance)
#
	
	


# Sub-wave enemy spawn timer
# Spawn new enemies (Timer for time between the enemies spawned in each sub-wave)
func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()
	


# Sub-wave start of sub-wave delay timer
# This will handle delay of starting each sub-wave
func _on_WaveStartDelayTimer_timeout() -> void:
	spawn_enemy()
	$SpawnTimer.start(waves[current_wave-1][current_sub_wave-1].spawn_rate)

#func someNameidk(curre


# Wave number set & get functions
func set_wave_number(wave_number):
	current_wave = wave_number
	HUD_node.emit_signal("wave_number_changed", current_wave)

func get_wave_number():
	return current_wave

func _on_StartNextWaveTimer_timeout() -> void:
	$WaveStartDelayTimer.start(waves[current_wave-1][current_sub_wave-1].pre_delay)


func issue_game_over(reason):
	if reason == "Waves complete":
		print("You finished all the waves! Good job! Game over.")







