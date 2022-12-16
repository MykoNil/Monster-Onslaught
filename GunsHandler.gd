extends Control

# This script handles the essentials for dealing with guns to the player. e.g., player will switch through weapons to equip

signal player_died


# Preload all gun scenes
var pistol_scene = preload("res://Game_Objects/Guns/Pistol.tscn")
var uzi_scene = preload("res://Game_Objects/Guns/Uzi.tscn")
var shotgun_scene = preload("res://Game_Objects/Guns/Shotgun.tscn")

var player_node
var gun_hold_position_node

var arena_node
var scene_tree


# Member variables for handling the purchasing, ownership, and equipping of weapons
var can_drop_weapons = false
var gun_equipped
# Array for weapons owned
var weapons_owned = []
#var weapons_carried = []
var equipped_gun_index = 0



func _ready():
	scene_tree = get_tree()
	player_node = $"../Player"
#	print(player_node)
	gun_hold_position_node = player_node.get_node("GunHoldPosition")

	arena_node = player_node.get_node("..")

	# Give player pistol to start the game
	give_player_gun_from_scene(pistol_scene)

	gun_equipped = player_node.get_node("Gun")
#	weapons_owned.push_back(gun_equipped)

	# For testing: give the player ownership of all the guns
	weapons_owned.push_back(gun_equipped)
#	var uzi_instance = uzi_scene.instance()
#	weapons_owned.push_back(uzi_instance)
	weapons_owned.push_back(shotgun_scene.instance())
#	for i in range(0, 2):

#func initialize():
#	scene_tree = get_tree()
#	player_node = $"../Player"
##	print(player_node)
#	gun_hold_position_node = player_node.get_node("GunHoldPosition")
#	print("skjldfkasjd;fkjas;kjfkjas;dkasffdsdf")
#	arena_node = player_node.get_node("..")
#
#	# Give player pistol to start the game
#	give_player_gun_from_scene(pistol_scene)
#
#	gun_equipped = player_node.get_node("Gun")
##	weapons_owned.push_back(gun_equipped)
#
#	# For testing: give the player ownership of all the guns
#	weapons_owned.push_back(gun_equipped)



func _physics_process(delta: float) -> void:
	# Press t to drop weapon
	if can_drop_weapons:
		if Input.is_action_just_pressed("drop_weapon"):
			var gun_held = gun_equipped#player_node.get_node("Gun")
			# If there is a gun in-hand
			if gun_held:
				drop_weapon(gun_held)
			elif not gun_held:
				var new_gun = pickup_weapon()
				print(new_gun)
				if new_gun:
					# Remove the gun from the arena
					new_gun.get_parent().remove_child(new_gun)
					give_player_gun_from_instance(new_gun)
	
	# Pressing e and q to switch through equipped guns
	if Input.is_action_just_pressed("switch_gun_right"):
		switch_weapon(1) # 1 is incrementing forward, so to the right
	if Input.is_action_just_pressed("switch_gun_left"):
		switch_weapon(-1)
	

func give_player_gun_from_instance(gun_instance):
	
	player_node.add_child(gun_instance)
	gun_instance.position = gun_hold_position_node.position
	player_node.gun = gun_instance
	gun_equipped = gun_instance

func give_player_gun_from_scene(gun_scene):
	var gun_instance = gun_scene.instance()
	player_node.add_child(gun_instance)
	gun_instance.position = gun_hold_position_node.position
	player_node.gun = gun_instance
	gun_equipped = gun_instance

func pickup_weapon():
	var pickup_distance = 100 #pixels
	var old_distance
	var gun_to_pickup
	
	for gun in scene_tree.get_nodes_in_group("guns"):
		var distance = (gun.global_position - player_node.global_position).length()
		
		if distance > pickup_distance:
			continue
		
		if not old_distance:
			old_distance = distance
			gun_to_pickup = gun
			continue
		
		if distance < old_distance:
			old_distance = distance
			gun_to_pickup = gun
	
	if gun_to_pickup:
		gun_to_pickup.is_held = true
	
	return gun_to_pickup

func drop_weapon(weapon):
	var old_position = weapon.global_position
	player_node.remove_child(weapon)
	weapon.global_position = old_position
	arena_node.add_child(weapon)
	gun_equipped = null
	weapon.is_held = false


# This handles rotating the equipping of owned weapons
func switch_weapon(direction):
	direction = sign(direction)
	
	equipped_gun_index += direction
	
	if weapons_owned.size() > 1: # If there is more than 1 weapon owned
		if equipped_gun_index > weapons_owned.size()-1: # Weapon exists to the right, otherwise, go to end of array to loop through the weapons
			equipped_gun_index = 0
		elif equipped_gun_index < 0:
			equipped_gun_index = weapons_owned.size()-1
		# Now switch the weapon from the player's hand and put other weapon in their hand
		player_node.remove_child(gun_equipped)
		give_player_gun_from_instance(weapons_owned[equipped_gun_index])
#		gun_equipped = weapons_owned[equipped_gun_index]
		
		
	






