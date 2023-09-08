extends KinematicBody2D

var ammo_reward = 50

# Give the ammo pickup some values
#func _ready() -> void:
#




func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var guns_handler = body.get_node("../GunsHandler")
		var equipped_gun = guns_handler.gun_equipped
		if equipped_gun:
			equipped_gun.ammo += ammo_reward
			
			get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
			queue_free()
#			set_physics_process(false)
