extends CanvasLayer


signal initialize_player
signal initialize_wave_number

signal player_hp_changed
signal player_cash_changed
signal wave_number_changed

signal weapon_equipped
signal gun_clip_ammo_changed

signal inform_player_of_wave_ending

var guns_side_view_images = { # Will have to move this into a script singleton (autoloaded script)
	# Tier 1
	"res://Game_Objects/Guns/Pistol.tscn": preload("res://Assets/Guns/SideView/Pistol.png"),
	"res://Game_Objects/Guns/Uzi.tscn": preload("res://Assets/Guns/SideView/Uzi-Simple.png"),
	"res://Game_Objects/Guns/Shotgun.tscn": preload("res://Assets/Guns/SideView/Shotgun.png"),
	
	# Tier 2
	"res://Game_Objects/Guns/SomeRapidFireGunForRenaming.tscn": preload("res://Assets/Guns/SideView/Uzi-Simple.png"),
	"res://Game_Objects/Guns/SomeSniperGun.tscn": preload("res://Assets/Guns/SideView/Uzi-Simple.png"),
}


# Get nodes
var player_HUD_control = null
var progress_bar = null
var hp_label
var progress_bar_smooth_tween_node

var cash_label

# Gun & clip nodes
var gun_texture_rect
var gun_shadow_texture_rect
var clip_label

var progress_bar_value = 0
var change_value = 1
var player_max_hp = 0

var wave_number_label
# For wave status indication
var wave_finished_label
var wave_finished_animation_player
var show_player_wave_ended_timer

var action_indicator_label
var reload_indicator_label
var reload_indicator_anim_player



# Get scenes





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_HUD_control = get_node("HUDControl")
	# if player_hp_control:
	progress_bar = player_HUD_control.get_node("HealthProgressBar")
	hp_label = progress_bar.get_node("HealthLabel")
	progress_bar_smooth_tween_node = player_HUD_control.get_node("HealthProgressBarTween")#progress_bar.get_node("Tween")
	
	# Gun & clip nodes
	gun_shadow_texture_rect = player_HUD_control.get_node("GunShadowTextureRect")
	clip_label = gun_shadow_texture_rect.get_node("ClipLabel")
	gun_texture_rect = gun_shadow_texture_rect.get_node("GunTextureRect")
	
	reload_indicator_label = gun_shadow_texture_rect.get_node("ReloadIndicatorLabel")
	reload_indicator_anim_player = reload_indicator_label.get_node("AnimationPlayer")
	
	# Player cash
	cash_label = player_HUD_control.get_node("CashLabel")
	
	wave_number_label = player_HUD_control.get_node("WaveNumLabel")
	wave_finished_label = wave_number_label.get_node("WaveFinishedLabel")
	wave_finished_animation_player = wave_finished_label.get_node("AnimationPlayer")
	show_player_wave_ended_timer = wave_finished_label.get_node("ShowPlayerNextWaveTimer")
	
	action_indicator_label = player_HUD_control.get_node("ActionIndicatorLabel")
	
	print("Ready from HUD")
	
	
	
	
	
	
	
	
#	wave_finished_animation_player.play("RESET")
#	var wave_finished_animation = wave_finished_animation_player.get_animation("Wave_Transition_Animation")
##	print(wave_finished_animation)
#	var text_anim_track_index = wave_finished_animation.find_track(".:text") # Because the animation is on the label
#	wave_finished_animation.track_set_key_value(text_anim_track_index, 1, "Wave " + str(3) + " started")
##	print("This is the track index: " + str(text_anim_track_index))
#	wave_finished_animation_player.play("Wave_Transition_Animation")


#func _process(delta: float) -> void:
#	if progress_bar:
#		animate_hp_bar()
#		update_hp_bar_label()
#

func display_gun_reloading_label(reloading):
	# First make it visible
	reload_indicator_label.text = "Reloading"
	if reloading:
		reload_indicator_label.visible = true
		# Next, play color pulsing animation
		
		reload_indicator_anim_player.play("pulsing")
		reload_indicator_anim_player.seek(0.0, true)
	else:
		reload_indicator_anim_player.stop()
		reload_indicator_label.visible = false
	
	if typeof(reloading) == TYPE_STRING:
		if reloading == "NoAmmo":
			reload_indicator_anim_player.play("pulsing")
			reload_indicator_anim_player.seek(0.0, true)
			reload_indicator_label.text = "Out of ammo."
		
	

# For testing the hp bar
func animate_hp_bar(hit_points):
#	print(progress_bar_value)
#	progress_bar_value += change_value
#
#	if progress_bar_value >= progress_bar.max_value or progress_bar_value <= progress_bar.min_value:
#		change_value = -change_value
	
#	progress_bar.value = progress_bar_value
#	var progress_bar_smooth_tween_node = get_node("Tween")
	var result = progress_bar_smooth_tween_node.interpolate_property(progress_bar, "value",
		progress_bar.value, hit_points, 0.125,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	progress_bar_smooth_tween_node.start()
#	print(result)

# Listen for value changes
func update_hp_bar_label(hit_points, max_hp):
	var hp_bar_label_text = "HP: " + str(hit_points) + "/" + str(max_hp)
	hp_label.text = hp_bar_label_text
	animate_hp_bar(hit_points)
	

func update_cash_label(cash):
	var cash_label_text = "Cash: $" + str(cash)
	cash_label.text = cash_label_text

func update_wave_number_label(wave_number):
	var wave_number_label_text = "Wave: " + str(wave_number)
	wave_number_label.text = wave_number_label_text


# Player values are changed ---------------------------------------------------

# Initialize the HUD for health when the player spawns
func _on_HUD_initialize_player(hit_points, max_hp, cash) -> void:
	if progress_bar and hp_label:
		player_max_hp = max_hp
		progress_bar.max_value = max_hp
		progress_bar.value = hit_points
		update_hp_bar_label(hit_points, max_hp)
		update_cash_label(cash)


# Player hp changed
func _on_HUD_player_hp_changed(hit_points) -> void:
	if progress_bar and hp_label:
#		progress_bar.set("value", hit_points)
		update_hp_bar_label(hit_points, player_max_hp)
		


func _on_HUD_player_cash_changed(cash) -> void:
	if cash_label:
		update_cash_label(cash)



# Wave values are changed -----------------------------------------------------

func _on_HUD_initialize_wave_number(wave_number) -> void:
	update_wave_number_label(wave_number)

func _on_HUD_wave_number_changed(wave_number) -> void:
	update_wave_number_label(wave_number)



## For testing if the guis work similar to Roblox. i.e., a gui button will not take input if invisible
#func _on_Button_pressed() -> void:
#	print("HUD Button")

# For updating the player's gun's clips & ammo HUD
func _on_HUD_gun_clip_ammo_changed(clip_amount, ammo_amount) -> void:
	clip_label.text = str(clip_amount) + "\n-----\n" + str(ammo_amount)

# Updating the name and image of the gun that the player has currently equipped
func _on_HUD_weapon_equipped(gun) -> void:
	gun_shadow_texture_rect.texture = guns_side_view_images[gun.get_filename()]
	gun_texture_rect.texture = guns_side_view_images[gun.get_filename()]
	print(gun.get_filename())

# This will change the value of the wave to display to the player, and play the animation to inform the player that the
# wave has ended and that another wave has started.
func _on_HUD_inform_player_of_wave_ending(current_wave_number) -> void:
#	wave_finished_animation_player.play("RESET")
	var wave_finished_animation = wave_finished_animation_player.get_animation("Wave_Transition_Animation")
#	print(wave_finished_animation)
	var text_anim_track_index = wave_finished_animation.find_track(".:text") # Because the animation is on the label
	wave_finished_animation.track_set_key_value(text_anim_track_index, 1, "Wave " + str(current_wave_number) + " started")
#	print("This is the track index: " + str(text_anim_track_index))
	wave_finished_animation_player.play("Wave_Transition_Animation")
	

# This timer is intended for use with the next wave label (which lets the player know the current wave has ended)
func _on_ShowPlayerNextWaveTimer_timeout() -> void:
	pass # Replace with function body.



