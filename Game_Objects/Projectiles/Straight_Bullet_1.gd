extends "res://Game_Objects/Projectiles/Bullets_Parent_Scene.gd"

var hit_points = 0

func _ready():
#	damage = 1
#	pierce = 6
	pass
#	print("Speed: " + str(speed))

func initialize():
#	print("Craup")
	knockback_strength = 30 * 60 # x pixels per frame (converted into pixels per second)
	damage = 1
	pierce = 4.5
	bullet_life_time = 1.5
