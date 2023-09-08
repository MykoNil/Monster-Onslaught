extends "res://Game_Objects/Projectiles/Bullets_Parent_Scene.gd"

var attack_status_effects = {
	"poison" : {
		"damage" : 1,
		"time" : 5
	}
}

func _ready():
	speed = 300
	damage = 10#3
	pierce = 0
#	attack_effectors = { # {"effect name" : [damage, seconds active]}
#		"poison" : [1]
#	}
#	damage_effects = ["poison"]

func initialize():
#	print("Craup")
#	damage = 5
#	pierce = 10
	bullet_life_time = 5


func bullet_hit_object(body):
	bullet.can_hit = false
	$CollisionShape2D.set_deferred("disabled", true)
	enemy_hit(body)
	bullet_blow_up()

func _on_HitDetector_body_entered(body: Node) -> void:
	#	print(body.get_instance_id())
	if bullet:
		if bullet.can_hit:
			if body.is_in_group("player"):
				if body.get_node("CollisionShape2D").disabled == false:
					bullet_hit_object(body)
			elif body.is_in_group("barricade"):
				if body.barricade_down == false:
					bullet_hit_object(body)
			
