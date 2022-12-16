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
#	GunsHandler.initialize()





# Confirmed: buttons that are invisible, though still there, cannot be interacted with
#func _on_Button2_pressed() -> void:
#	print("Other button")
#	$Button2.visible = false



