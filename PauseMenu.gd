extends Control

# For pausing the game
#if Input.is_action_just_pressed("pause_game"):
#	print("Pause the game")

var is_paused = false setget set_is_paused
var scene_tree

var shop_menu_node

func _ready():
	visible = false
	scene_tree = get_tree()
	
	shop_menu_node = get_node("ShopMenu")


func set_is_paused(new_value):
	is_paused = new_value
	get_tree().paused = is_paused
	visible = is_paused
	if not is_paused:
		shop_menu_node.visible = false
		$SettingsMenu.visible = false
#	else:
#		$ResumeButton.shape_visible = false
	
	# Make sure any and all guns don't have the trigger held
	for gun in scene_tree.get_nodes_in_group("guns"):
		gun.gun_trigger_held = false
	
	for thumbstick in scene_tree.get_nodes_in_group("thumbsticks"):
		thumbstick.joystick_active = false
		thumbstick.keep_joystick_focus = false
		thumbstick.button_pressed = false
		
		if thumbstick.name == "LeftJoystick":
			thumbstick.reset_thumbstick()
	
	
func _unhandled_input(event):
#	print("yee")
	if event.is_action_pressed("pause_game"):
		self.is_paused = !is_paused


# Return to the main menu
func _on_ReturnToMenuButton_pressed() -> void:
	change_the_scene("res://Game_Objects/Menus/MainMenu.tscn/")

func _on_OpenShopButton_pressed() -> void:
	shop_menu_node.visible = true


# When changing scenes, probably will want to unpause the game
func change_the_scene(scene_path):
	set_is_paused(false)
	scene_tree.change_scene(scene_path)
#	shop_menu_node.visible = true
#	GunsHandler.initialize()





# Confirmed: buttons that are invisible, though still there, cannot be interacted with
#func _on_Button2_pressed() -> void:
#	print("Other button")
#	$Button2.visible = false





func _on_ResumeGameButton_button_down() -> void:
#	shop_menu_node.visible = true
	set_is_paused(false)



# ---------------------------------------------------------- Settings ----------------------------------------------------------
# For displaying the settings menu
func _on_OpenSettingsButton_pressed() -> void:
	$SettingsMenu.visible = true


func _on_CloseSettingsButton_pressed() -> void:
	$SettingsMenu.visible = false
	





# Activate touchscreen controls
func _on_Button2_pressed() -> void:
	GameSettings.control_scheme = 1


# Activate keyboard & mouse controls
func _on_Button1_pressed() -> void:
	GameSettings.control_scheme = 0




