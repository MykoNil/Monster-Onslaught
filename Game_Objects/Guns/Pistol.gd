extends "res://Game_Objects/Guns/Gun.gd"


#primary_shot_debounce = 

func _ready():
	damage = 1
	shots_per_second = 0
	gun_name = "Pistol"
	
#	print("Test")
	bullet_type = straight_bullet_1
	manual_debounce_cancel = true




