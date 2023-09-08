extends CanvasLayer




var left_thumbstick
var right_thumbstick

var children

func _ready():
	children = get_children()


func display_touchscreen_controls(display):
	for child in children:
		print(child)
		if child.name == "PauseButton":
			if display:
				child.visible = display
		else:
			child.visible = display















#signal use_move_vector
#
#var player_node
#var touchscreen_button
#var joystick_active = false
#
#var viewport
#var camera
#var screen_size = Vector2(0, 0)
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	player_node = get_node("..")
#	touchscreen_button = self
#	camera = player_node.get_node("../../Camera2D")
#	viewport = get_viewport()
#
#
#
#func _process(delta: float) -> void:
#	screen_size = Vector2(viewport.get_size_override().x, viewport.get_size_override().y) * camera.zoom.x
#
#
#func _input(event: InputEvent) -> void:
#	if event is InputEvent or event is InputEventScreenDrag:
#		if touchscreen_button.is_pressed():
##			print(event.position)
#			joystick_active = true
#			var move_vector = calculate_move_vector(event.position)
#			emit_signal("use_move_vector", move_vector)
#
#			# Deactivate the thumbstick if the position goes passed the center of the screen
#			if event.position.x > screen_size.x:
#				joystick_active = false
#
#	if event is InputEventScreenTouch:
#		if event.pressed == false:
#			joystick_active = false
#
#func calculate_move_vector(event_position):
#	var texture_center = touchscreen_button.position + Vector2(64, 64)#touchscreen_button.normal.get_size().x / 2
##	var point_from_center_to_mouse = (event_position - texture_center)
##	var max_distance_from_center_x = texture_center.x + 64
##	var distance_from_center_x = max_distance_from_center_x - texture_center.x
#	var distance_from_center_x = event_position.x - texture_center.x
#	var percentage_of_distance_to_edge_x = distance_from_center_x / 64 # could also use half the size of either x or y of the circle
#
#	var distance_from_center_y = event_position.y - texture_center.y
#	var percentage_of_distance_to_edge_y = distance_from_center_y / 64
#
#	var move_vector = Vector2(percentage_of_distance_to_edge_x, percentage_of_distance_to_edge_y).limit_length(1)
#	var thumbstick_position = move_vector * 64
#	touchscreen_button.get_node("InnerCircle").position = thumbstick_position
#
#	return move_vector
#
