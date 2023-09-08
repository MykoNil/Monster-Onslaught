extends Control

func _ready():
	$TutorialImage.visible = false
#	var viewport = get_viewport()
#	print(viewport.size)
#	print(OS.get_screen_size())
#
#	var test_screen = ProjectSettings.set_setting("display/window/size", Vector2(OS.get_screen_size().x/2, OS.get_screen_size().y/2))
#	print(ProjectSettings.get_setting("display/window/size"))
##	viewport.size = ProjectSettings.get_setting("display/window/size")
#	OS.window_size = ProjectSettings.get_setting("display/window/size")


# Show the tutorial image on-click
func _on_Button2_button_up() -> void:
	$TutorialImage.visible = true

# Close the tutorial
func _on_CloseTutorialButton_button_up() -> void:
	$TutorialImage.visible = false
