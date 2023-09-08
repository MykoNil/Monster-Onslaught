extends TouchScreenButton

signal use_move_vector
signal holding_shot

var player_node
#var 
var touchscreen_button
var joystick_active = false
var joystick_can_be_activated = true
var button_pressed = false

var viewport
var camera
var screen_size = Vector2(0, 0)

var joystick_area_radius = 64

var keep_joystick_focus = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = get_node("../..")
	touchscreen_button = self
	camera = player_node.get_node("../../Camera2D")
	viewport = get_viewport()
	


func _process(delta: float) -> void:
	screen_size = Vector2(viewport.get_size_override().x, viewport.get_size_override().y)# * camera.zoom.x


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
#		if event.position.x > screen_size.x/2:
		var within_radius = (event.position - (touchscreen_button.position + Vector2(joystick_area_radius, joystick_area_radius))).length() <= joystick_area_radius
		
		if event is InputEventScreenTouch:
			if event.is_pressed() and not joystick_active and within_radius:
#				joystick_active = true
				keep_joystick_focus = true
				emit_signal("holding_shot", true)
		
#		if event.is_pressed():
#
#			emit_signal("holding_shot", true)
#			print("DSLKDFL;AKSD;FKASL;DKFASDF" + str(touchscreen_button.is_pressed()))
#		if touchscreen_button.is_pressed():
##			emit_signal("holding_shot", true)
##			print(event.position)
##			joystick_active = true
#			if keep_joystick_focus:
#				joystick_active = true
#			print(event)
#			if event.position.x < screen_size.x/2:
##			joystick_can_be_activated = false
#				joystick_active = false
#				keep_joystick_focus = false
#			if joystick_can_be_activated:
		
		if event.position.x < screen_size.x/2:
			joystick_active = false
		else:
			if keep_joystick_focus:
				if button_pressed:
					joystick_active = true
#				joystick_active = true
		
		if within_radius and keep_joystick_focus:
			joystick_active = true
#			keep_joystick_focus = false
		# If the touch is brought back to the thumbstick without lisfting a finger
#		if within_radius:
#			keep_joystick_focus = true
#		if button_pressed:
#			joystick_active = true
#		if keep_joystick_focus:
#			joystick_active = true
#				joystick_active = false
		# Deactivate the thumbstick if the position goes passed the center of the screen
		if joystick_active:
			emit_signal("holding_shot", true)
			var aim_vector = calculate_move_vector(event.position)
			emit_signal("use_move_vector", aim_vector)
#		if event.position.x > screen_size.x:
##			joystick_can_be_activated = false
#			joystick_active = false
#		else:
#			emit_signal("holding_shot", false)
	
#	if event is InputEventScreenTouch:
#		if event.pressed == false:
#			joystick_active = false
#			keep_joystick_focus = false
#			button_pressed = false
#			emit_signal("holding_shot", false)
#			joystick_can_be_activated = true

func calculate_move_vector(event_position):
	var texture_center = touchscreen_button.position + Vector2(joystick_area_radius, joystick_area_radius)#touchscreen_button.normal.get_size().x / 2
#	var point_from_center_to_mouse = (event_position - texture_center)
#	var max_distance_from_center_x = texture_center.x + 64
#	var distance_from_center_x = max_distance_from_center_x - texture_center.x
	var distance_from_center_x = event_position.x - texture_center.x
	var percentage_of_distance_to_edge_x = distance_from_center_x / joystick_area_radius # could also use half the size of either x or y of the circle
	
	var distance_from_center_y = event_position.y - texture_center.y
	var percentage_of_distance_to_edge_y = distance_from_center_y / joystick_area_radius
	
	var move_vector = Vector2(percentage_of_distance_to_edge_x, percentage_of_distance_to_edge_y).limit_length(1)
	var thumbstick_position = move_vector * joystick_area_radius
	touchscreen_button.get_node("InnerCircle").position = thumbstick_position
	
	return move_vector
	


func _on_RightJoystick_pressed() -> void:
#	keep_joystick_focus = true
#	joystick_active = true
	button_pressed = true
#	if keep_joystick_focus:
#		joystick_active = true
#	keep_joystick_focus = true
#	if event.position.x < screen_size.x/2:
#		joystick_active = false
#		keep_joystick_focus = false


func _on_RightJoystick_released() -> void:
	joystick_active = false
	keep_joystick_focus = false
	button_pressed = false
	emit_signal("holding_shot", false)
