extends Control

var shop_item_button_scene = preload("res://Game_Objects/Menus/ShopMenuItemButton.tscn")
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

var gun_instances = []
## Guns tabs buttons
#var guns_shop_tab_button
#var support_shop_tab_button

var shop_items_control_node

# Guns tabs lists
var guns_tab_list
var support_tab_list

var guns_group_name = "guns"


func _ready():
#	print("Test: " + str(gun_scenes[0].bullet_type))
	scene_tree = get_tree()
	
	shop_items_control_node = get_node("ColorRect/ShopItems")
	# Initialize the shop tab lists
	guns_tab_list = shop_items_control_node.get_node("GunsList/VBoxContainer")
	
	
	# Add the guns as node instances of their respective scenes
	for gun_scene in gun_scenes:
		var gun_instance = gun_scene.instance()
		gun_instances.push_back(gun_instance)
		gun_instance.add_to_group(guns_group_name)
		self.add_child(gun_instance)
	
	guns_in_game = scene_tree.get_nodes_in_group(guns_group_name)
	print("Test from shop menu: " + str(guns_in_game))
	
	if guns_in_game:
		# Go through each gun and set up the corresponding shop buttons for each one
		for gun in guns_in_game:
			var shop_gun_button_instance = shop_item_button_scene.instance()
			
			# Connect "pressed" signal for each shop item button
			shop_gun_button_instance.connect("pressed", self, "shop_item_button_clicked", [shop_gun_button_instance])
			
			# Set the image of the gun
			shop_gun_button_instance.get_node("GunTextureRect").texture = guns_side_view_images[gun.gun_name]
			
			# display the damage per second
			var damage_per_second = gun.damage * gun.shots_per_second
			var dps_container_label = shop_gun_button_instance.get_node("DPSContainer/Label")
			dps_container_label.text = str(damage_per_second) + "/s"
			
			# Add gun to shop menu
			guns_tab_list.add_child(shop_gun_button_instance)
#			print("Agh")


# Retrieve shop item info and display it to the player
func shop_item_button_clicked(button):
	print("Button pressed")
	print(button)


## This function will initialize the shop by adding the proper guns and barricades buttons
#func setup_shop():
#	pass

