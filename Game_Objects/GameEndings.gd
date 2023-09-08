extends Control

# This script will handle all of the stuff for when the player either dies or wins the game.


var scene_tree
var pause_menu

var fade_animation_player
var fade_color_rect
var ending_type = ""

func _ready() -> void:
	scene_tree = get_tree()
	pause_menu = get_node("../PauseMenu")
	
	fade_animation_player = get_node("AnimationPlayer")
	fade_color_rect = get_node("FadeColorRect")
	
	# Make all items invisible to start
	$SurvivedScreen.visible = false
	$DeathScreen.visible = false
#	fade_color_rect.visible = false

# Return to main menu
func _on_ReturnToMenuButton_pressed() -> void:
	pause_menu.set_is_paused(false)
	change_the_scene("res://Game_Objects/Menus/MainMenu.tscn/")

# When changing scenes, probably will want to unpause the game
func change_the_scene(scene_path):
#	set_is_paused(false)
	scene_tree.change_scene(scene_path)

# This will activate the appropriate ending, based on outcome
func _on_MobSpawner_pause_game_on_ending(which_ending) -> void:
	pause_menu.set_is_paused(true) # Pause the game.
	ending_type = which_ending
	fade_color_rect.color = Color.transparent
	visible = true
	pause_menu.visible = false
	fade_animation_player.play("fade_in_ending")
	

func show_appropriate_ending():
	if ending_type == "player_survived":
		$DeathScreen.visible = false
		$SurvivedScreen.visible = true
	elif ending_type == "player_died":
		$DeathScreen.visible = true
		$SurvivedScreen.visible = false

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in_ending":
		show_appropriate_ending()
		fade_animation_player.play("fade_out_ending")
	elif anim_name == "fade_out_ending":
		fade_color_rect.visible = false


func _on_RestartGameButton_pressed() -> void:
#	change_the_scene("res://Game_Objects/Menus/MainMenu.tscn/")
	pause_menu.set_is_paused(false)
	scene_tree.reload_current_scene()
