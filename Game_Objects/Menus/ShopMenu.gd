extends Control

signal player_cash_changed

var shop_item_gun_button_scene = preload("res://Game_Objects/Menus/ShopMenuItemButton.tscn")
var shop_item_barricade_button_scene = preload("res://Game_Objects/Menus/ShopMenuItemButtonBarricade.tscn")
var barricade_scene = preload("res://Game_Objects/Barricade.tscn")

var scene_tree
var guns_in_game

var guns_side_view_images = {
	"Pistol": preload("res://Assets/Guns/SideView/Pistol.png"),
	"Uzi": preload("res://Assets/Guns/SideView/Uzi-Simple.png"),
	"Shotgun": preload("res://Assets/Guns/SideView/Shotgun.png"),
}

var gun_scenes = [
	preload("res://Game_Objects/Guns/Pistol.tscn"), # Pistol
	preload("res://Game_Objects/Guns/Uzi.tscn"), # Uzi
	preload("res://Game_Objects/Guns/Shotgun.tscn"), # Shotgun
]

var barricade_upgrades_owned = [
	
]


# Names of groups (prevent typos)
var guns_group_name = "guns"
var barricades_group_name = "barricade"


var gun_instances = []
var shop_item_selected
## Guns tabs buttons
#var guns_shop_tab_button
#var support_shop_tab_button

var shop_items_control_node

# Guns tabs lists
var guns_tab_list
var support_tab_list
var previous_selected_tab = "weapons"

# For guns list
var gun_stats_container
var damage_per_shot_label
var shots_per_second_label
var damage_per_second_label

var item_texture_rect
var item_name_label
var item_description_label

var purchase_button
var item_cost_label
var cash_label

# Shop tabs
var shop_tabs_container
var weapons_tab_button
var support_tab_button
#var something



var guns_handler
var player_node

var weapon_owned
var weapon_equipped

#var purchase_button



#var guns_group_name = "guns"


func _ready():
#	print("Test: " + str(gun_scenes[0].bullet_type))
	scene_tree = get_tree()
	
	shop_items_control_node = get_node("ColorRect/ShopItems")
	# Initialize the shop tab lists
	guns_tab_list = shop_items_control_node.get_node("GunsList/VBoxContainer") # Vertical scrollable list of guns
	support_tab_list = shop_items_control_node.get_node("SupportsList/VBoxContainer")
	
	shop_tabs_container = shop_items_control_node.get_node("ShopTabs")
	
	var item_info_control_node = get_node("ColorRect/ItemInfoControl")
	
	# For guns list
	gun_stats_container = item_info_control_node.get_node("GunStatsContainer")
	damage_per_shot_label = gun_stats_container.get_node("DamagePerShotLabel")
	shots_per_second_label = gun_stats_container.get_node("ShotsPerSecondLabel")
	damage_per_second_label = gun_stats_container.get_node("DamagePerSecondLabel")
	
	item_texture_rect = item_info_control_node.get_node("GunTexture")
	item_name_label = item_texture_rect.get_node("Name")
	item_description_label = item_info_control_node.get_node("Description")
	
	purchase_button = item_info_control_node.get_node("PurchaseButton")
	item_cost_label = purchase_button.get_node("CostLabel")
	
	reset_item_info()
#	print(item_cost_label.get_path())
	
	guns_handler = get_node("/root/Main/Arena1/GunsHandler")
	player_node = get_node("/root/Main/Arena1/Player")
	cash_label = get_node("CashLabel")
	
	
	# Set up shop tab buttons
	# Connect "pressed" signal for each shop tab button
	for shop_tab_button in shop_tabs_container.get_children():
		shop_tab_button.connect("pressed", self, "shop_tab_button_clicked", [shop_tab_button])
	
	
	# Set up support items
	var instanced_barricade = barricade_scene.instance()
	
	for barricade_index in instanced_barricade.barricade_upgrades.size():
		var barricade_upgrade_dictionary = instanced_barricade.barricade_upgrades[barricade_index]
#		print("skdflskdjflksjdlfkjsldjfs: " + str(barricade_index))
		var shop_barricade_button_instance = shop_item_barricade_button_scene.instance()
		
		# Connect "pressed" signal for each shop item button
		shop_barricade_button_instance.connect("pressed", self, "shop_item_button_clicked", [shop_barricade_button_instance, [instanced_barricade, barricade_index], barricade_upgrade_dictionary["image"]])
		# Set the image of the gun
		var shop_barricade_button_texture_rect = shop_barricade_button_instance.get_node("TextureRect")
		shop_barricade_button_texture_rect.texture = barricade_upgrade_dictionary["image"]
		shop_barricade_button_texture_rect.rect_scale = Vector2(1, 1)
		
		var shop_barricade_button_cost_label = shop_barricade_button_instance.get_node("CostLabel")
		shop_barricade_button_cost_label.text = "$" + str(barricade_upgrade_dictionary.cost)
		
		# Add gun to shop menu
		support_tab_list.add_child(shop_barricade_button_instance)
	
	# Add the guns as node instances of their respective scenes
	for gun_scene in gun_scenes:
		var gun_instance = gun_scene.instance()
		gun_instances.push_back(gun_instance)
		print(gun_instances[0])
		gun_instance.add_to_group(guns_group_name)
		gun_instance.visible = false
		self.add_child(gun_instance)
	
	guns_in_game = scene_tree.get_nodes_in_group(guns_group_name)
	print("Test from shop menu: " + str(guns_in_game))
	
	if guns_in_game:
		var counter = 0
		# Go through each gun and set up the corresponding shop buttons for each one
		for gun in gun_instances:
			var shop_gun_button_instance = shop_item_gun_button_scene.instance()
			
			# Connect "pressed" signal for each shop item button
			shop_gun_button_instance.connect("pressed", self, "shop_item_button_clicked", [shop_gun_button_instance, [gun_instances[counter], 0], guns_side_view_images[gun.gun_name]])
			counter += 1
			# Set the image of the gun
			shop_gun_button_instance.get_node("GunTextureRect").texture = guns_side_view_images[gun.gun_name]
			
			# display the damage per second
			var damage_per_second = gun.damage * gun.shots_per_second
			var dps_container_label = shop_gun_button_instance.get_node("DPSContainer/Label")
			dps_container_label.text = str(damage_per_second) + "/s"
			
			var cost_label = shop_gun_button_instance.get_node("CostLabel")
			cost_label.text = "$" + str(gun.cost)
			
			# Add gun to shop menu
			guns_tab_list.add_child(shop_gun_button_instance)
#			print("Agh")
	
	# Get the barricades
	
	
	

func reset_item_info():
	damage_per_shot_label.text = "--"
	shots_per_second_label.text = "--"
	damage_per_second_label.modulate = Color("ffffff")
	damage_per_second_label.text = "--"
	
	item_texture_rect.texture = null
	item_name_label.text = "--"
	item_description_label.text = "--"
	item_cost_label.text = ""

func shop_tab_button_clicked(tab_button):
	print("Tab button: " + str(tab_button.name))
	
	# We will now determine what should be visible and what should not be. Also will blank out the item describer section
	
	if tab_button.is_in_group("weaponstab"): # Weapons
		if previous_selected_tab != "weapons":
			guns_tab_list.get_parent().visible = true
			support_tab_list.get_parent().visible = false
			previous_selected_tab = "weapons"
			reset_item_info()
	elif tab_button.is_in_group("supporttab"): # Support
		if previous_selected_tab != "support":
			support_tab_list.get_parent().visible = true
			guns_tab_list.get_parent().visible = false
			previous_selected_tab = "support"
			reset_item_info()
#	elif tab_button.is_in_group("whateverthiswillbe"):
#		pass
	


# SHOP ITEM SELECTION -----------------------------------------------
# Retrieve shop item info and display it to the player
func shop_item_button_clicked(button, item, item_texture):
	print("This is the group of the shop item button: " + str(item[0].get_groups()))
	if item[0].is_in_group(guns_group_name): # If the shop item is a gun
		var gun = item[0]
		var damage_per_shot = gun.damage
		var shots_per_second = gun.shots_per_second
		var damage_per_second = damage_per_shot * shots_per_second
		
		print("Damage per shot: " + str(damage_per_shot))
		print(damage_per_shot_label)
		
		damage_per_shot_label.text = "Damage per shot: " + str(damage_per_shot)
		shots_per_second_label.text = "Shots per second: " + str(shots_per_second)
		damage_per_second_label.modulate = Color("ffffff")
		damage_per_second_label.text = "Damage per second: " + str(damage_per_second)
		
		item_texture_rect.texture = item_texture
		item_name_label.text = gun.gun_name
		item_description_label.text = gun.shop_description
		
		item_cost_label.text = "$" + str(gun.cost)
		
		shop_item_selected = [gun, null]
#		purchase_button.text = "Equip"
		
		# Now check if the player can purchase this item (Not already owned? Has enough cash?)
		# This is for the visuals
		
	#	print(guns_handler.weapons_owned)
		# Not owned?
	#	var weapon_owned = false
		# Check if the weapon is owned
		weapon_owned = false
		for gun_owned in guns_handler.weapons_owned:
			if gun_owned.get_filename() == gun.get_filename():
				weapon_owned = true
		if weapon_owned:
			print("Weapon owned")
#			# Now check if the weapon is already equipped
#			weapon_equipped = false
#			for gun_equipped in guns_handler.weapons_equipped:
#				if gun_equipped.get_filename() == gun.get_filename():
#					weapon_equipped = true
#			if not weapon_equipped:
#				purchase_button.text = "Equip"
#			else:
#				purchase_button.text = "Equipped"
				
		else:
			print("Weapon not owned")
			purchase_button.text = "Purchase"
			# Has enough cash?
		# Now check if the weapon is already equipped
		weapon_equipped = false
		for gun_equipped in guns_handler.weapons_equipped:
			if gun_equipped.get_filename() == gun.get_filename():
				weapon_equipped = true
		if not weapon_equipped:
			if weapon_owned:
				purchase_button.text = "Equip"
			else:
				purchase_button.text = "Purchase"
		else:
			purchase_button.text = "Equipped"
	# For support items
	elif item[0].is_in_group(barricades_group_name):
		var barricade = item[0]
#		print("Just clicked: " + str(item.name))
		print("Testllllllllll")
		print(barricade.barricade_upgrades[item[1]])
		
		var barricade_upgrade_dictionary = barricade.barricade_upgrades[item[1]]
		
		damage_per_shot_label.text = ""
		shots_per_second_label.text = ""
		damage_per_second_label.modulate = Color("cd2222")
		damage_per_second_label.text = "HP: " + str(barricade_upgrade_dictionary.hp)
		
		item_texture_rect.texture = barricade_upgrade_dictionary.image
		item_name_label.text = barricade_upgrade_dictionary.name
		item_description_label.text = "--"
		
		item_cost_label.text = "$" + str(barricade_upgrade_dictionary.cost)
		
		
		shop_item_selected = [barricade, barricade_upgrade_dictionary]#barricade.barricade_upgrades[item[1]]
		
#		purchase_button.text = "Equip"
		
		var baricade_upgrade_owned = false
	#	var weapon_owned = false
		for barricade_upgrade_owned_name in barricade_upgrades_owned:
			if barricade_upgrade_owned_name == barricade_upgrade_dictionary.name:
				baricade_upgrade_owned = true
		if baricade_upgrade_owned:
			print("Barricade upgrade owned")
			purchase_button.text = "Equip"
			change_barricades(barricade_upgrade_dictionary)
		else:
			print("Barricade upgrade not owned")
			purchase_button.text = "Purchase"
		


# SHOP ITEM PURCHASE -----------------------------------------------
# Purchase/equip button clicked
func _on_PurchaseButton_pressed() -> void:
	if shop_item_selected[0].is_in_group(guns_group_name): # If the selected shop item is a gun
		print("Item selected: " + str(shop_item_selected))
		var selected_gun = shop_item_selected[0]
		
		# For guns
		if not weapon_owned:
			# Does player have enough cash to purchase?
			if player_node.cash >= selected_gun.cost: # Player can purchase
				print("Had enough cash. Purchased")
				# Take away amount of cash and add item to player's owned array
				player_node.cash -= selected_gun.cost
				
				# Duplicate the gun instance and add it to the gunshandler
				var gun_selected_duplicate = selected_gun.duplicate()
				gun_selected_duplicate.visible = true
				guns_handler.weapons_owned.push_back(gun_selected_duplicate)
				
				# Successful purchase. Will now display "Equip"
				purchase_button.text = "Equip"
				weapon_owned = true
		else:
			print("Already owned. Not purchased")
			# Will equip the gun now
			
			# Check for if the player already has the owned weapon equipped
			if not weapon_equipped:
				# Duplicate the gun instance and add it to the gunshandler
				var gun_selected_duplicate = selected_gun.duplicate()
				gun_selected_duplicate.visible = true
				guns_handler.weapons_equipped.push_back(gun_selected_duplicate)
				purchase_button.text = "Equipped"
				weapon_equipped = true
#			else:
#				purchase_button.text = "Equipped"
			
		
	# For support items
	elif shop_item_selected[0].is_in_group(barricades_group_name):
		var barricade_upgrade_dictionary = shop_item_selected[1]
		
		# Does player have enough cash to purchase?
		print("What is the index? --> " + str(barricade_upgrades_owned.find(barricade_upgrade_dictionary.name)))
		if barricade_upgrades_owned.find(barricade_upgrade_dictionary.name) <= -1: # If upgrade is not owned
			
			# If the player has enough cash
			if player_node.cash >= barricade_upgrade_dictionary.cost:#shop_item_selected.barricade_upgrades[item[1]].cost: # Player can purchase
				print("Had enough cash. Purchased")
				
				# Take away amount of cash and add item to player's owned array
				player_node.cash -= barricade_upgrade_dictionary.cost
				
				# Add upgrade to owned upgrades array
				barricade_upgrades_owned.push_back(barricade_upgrade_dictionary.name)
				
				# Successful purchase. Will now display "Equip"
				purchase_button.text = "Equip"
			else:
				print("Not enough cash.")
		else:
			print("Owned. Not purchased. Equipped?")
			change_barricades(barricade_upgrade_dictionary)
			



func change_barricades(barricade_upgrade_dictionary):
	# Now upgrade the barricades
	for barricade in scene_tree.get_nodes_in_group("barricade"):
		var barricade_sprite = barricade.get_node("Sprite")
		barricade_sprite.texture = barricade_upgrade_dictionary.image
		barricade.max_hp = barricade_upgrade_dictionary.hp

## This function will initialize the shop by adding the proper guns and barricades buttons
#func setup_shop():
#	pass

# Fired whenever the player's cash value changes
func _on_ShopMenu_player_cash_changed(cash) -> void:
	# Just need to update the cash label with the player's current cash value
	cash_label.text = "Cash: $" + str(cash)
	
