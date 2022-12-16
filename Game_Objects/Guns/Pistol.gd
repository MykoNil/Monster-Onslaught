extends "res://Game_Objects/Guns/Gun.gd"


#primary_shot_debounce = 

func _ready():
	bullet_type = straight_bullet_1
#	var bullet_with_info = bullet_type.instance()
	var bullet_info = .get_bullet_info()
	
	damage = bullet_info.damage_per_shot
	shots_per_second = bullet_info.shots_per_second
	cost = 0
	
#	bullet_with_info.queue_free()
	
	gun_name = "Pistol"
	shop_description = "This gun is loaded with a state-of-the-art, fast-as-you-can-pull-the-trigger rate of fire!"
	
#	print("Test")
	manual_debounce_cancel = true




