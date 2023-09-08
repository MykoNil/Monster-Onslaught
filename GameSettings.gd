extends Node

#signal control_scheme_updated


var reload_on_empty_clip = true

var control_scheme = 0 setget control_scheme_changed # 0 = keyboard & mouse, 1 = touchscreen


func control_scheme_changed(new_value):
	control_scheme = new_value
	print(control_scheme)
