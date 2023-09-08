extends "res://Game_Objects/Guns/Gun.gd"


#primary_shot_debounce = 

func _ready():
	bullet_type = straight_bullet_1
#	var bullet_with_info = bullet_type.instance()
	var bullet_info = .get_bullet_info()
	
	damage = bullet_info.damage_per_shot
	shots_per_second = bullet_info.shots_per_second
	cost = 0
	
	# Bullet overrides
	bullet_damage = 2
	bullet_knockback_strength = 5 * 60 # x pixels per frame (converted into pixels per second)
#	bullet_hp = 3
	
	# Gun clips/ammo
	clip_max_size = 24
	clip_size = clip_max_size
	ammo = clip_max_size * 5
	
#	bullet_with_info.queue_free()
	
	gun_name = "Pistol"
	shop_description = "This gun is loaded with a state-of-the-art, fast-as-you-can-pull-the-trigger rate of fire!"
	
#	print("Test")
	manual_debounce_cancel = true




