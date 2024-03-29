extends "res://Game_Objects/Projectiles/Bullets_Parent_Scene.gd"

# This type of bullet will pierce through armor

var hit_points = 3 setget set_hp
var enemies_hit = []


#func _ready():
##	print("Yee")
#	print("Craup")
#	damage = 2
#	pierce = 1


func initialize():
#	print("Craup")
	knockback_strength = 10 * 60 # x pixels per frame (converted into pixels per second)
	damage = 5
	pierce = 10
	bullet_life_time = 0.5
	


func destroy_bullet():
	# Bullet has lost all hp. Disable and destroy it
	bullet.can_hit = false#bullet.can_hit = false
	$CollisionShape2D.set_deferred("disabled", true)
	.bullet_blow_up()

func set_hp(new_value):
	hit_points = new_value
	
	if hit_points <= 0:
		destroy_bullet()

func get_hp():
	return hit_points


func handle_bullet_pierce(body):
	enemies_hit.push_back(body)
	self.hit_points -= 1
	.enemy_hit(body)

func _on_HitDetector_body_entered(body: Node) -> void:
	#	print(body.get_instance_id())
#	print("Tasty soup")
	if bullet:
		if self.hit_points > 0: # Bullet can still hit enemies
			if body.is_in_group("enemies"): # If it hits an enemy
				if body.get_node("CollisionShape2D").disabled == false: # If enemy can be hit
					if enemies_hit.size() > 0:
						var enemy_already_hit = false
						for enemy_hit in enemies_hit:
							if body == enemy_hit:
								enemy_already_hit = true
								break
						
						if not enemy_already_hit:
							handle_bullet_pierce(body)
					else:
						handle_bullet_pierce(body)
		
