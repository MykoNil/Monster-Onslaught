extends CanvasLayer


signal initialize_player
signal initialize_wave_number

signal player_hp_changed
signal player_cash_changed
signal wave_number_changed



# Get nodes
var player_HUD_control = null
var progress_bar = null
var hp_label

var cash_label

var progress_bar_value = 0
var change_value = 1

var wave_number_label
var action_indicator_label


# Get scenes





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_HUD_control = get_node("HUDControl")
	# if player_hp_control:
	progress_bar = player_HUD_control.get_node("ProgressBar")
	hp_label = player_HUD_control.get_node("HealthLabel")
	
	# Player cash
	cash_label = player_HUD_control.get_node("CashLabel")
	
	wave_number_label = player_HUD_control.get_node("WaveNumLabel")
	
	action_indicator_label = player_HUD_control.get_node("ActionIndicatorLabel")
	
	
	print("Ready from HUD")


#func _process(delta: float) -> void:
#	if progress_bar:
#		animate_hp_bar()
#		update_hp_bar_label()
#


# For testing the hp bar
func animate_hp_bar():
#	print(progress_bar_value)
	progress_bar_value += change_value
	
	if progress_bar_value >= progress_bar.max_value or progress_bar_value <= progress_bar.min_value:
		change_value = -change_value
	
	progress_bar.value = progress_bar_value

# Listen for value changes
func update_hp_bar_label():
	var hp_bar_label_text = "HP: " + str(progress_bar.get("value")) + "/" + str(progress_bar.get("max_value"))
	hp_label.text = hp_bar_label_text

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
		progress_bar.set("max_value", max_hp)
		progress_bar.set("value", hit_points)
		update_hp_bar_label()
		update_cash_label(cash)


# Player hp changed
func _on_HUD_player_hp_changed(hit_points) -> void:
	if progress_bar and hp_label:
		progress_bar.set("value", hit_points)
		update_hp_bar_label()
		


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







