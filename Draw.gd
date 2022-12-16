extends Node2D

signal draw_from_player_to_mouse



var mouse_position = Vector2.ZERO
var player_position = Vector2.ZERO



func _on_Draw_draw_from_player_to_mouse(player_pos, mouse_pos) -> void:
	mouse_position = mouse_pos
	player_position = player_pos
	update()
#	print(mouse_position)



func _draw() -> void:
	draw_line(player_position, mouse_position, Color(1, 0, 0), 1, false)

