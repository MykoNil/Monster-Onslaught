extends Area2D

var bullet = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet = get_parent()
	pass


func _process(delta: float) -> void:
	pass
#	var collisions = get_overlapping_bodies()
#
##	enemy_hit(collisions)
#	if collisions:
#		enemy_hit(collisions[0])
#		print(collisions[0])

#	for body in collisions:
#		print(body.get_instance_id())
#		enemy_hit(body)


#func enemy_hit(body):
##	print("srfjlesakfja;skidjf;oeijs;lkef;olsijef;lkse;sk")
#	if bullet:	
#		body.emit_signal("has_been_hit", bullet.damage)
		



#func _on_HitDetector_body_entered(body: Node) -> void:
##	print(body.get_instance_id())
##	print(body.is_in_group("enemies"))
#	if bullet:
#		if bullet.can_hit:
##			print(body.is_in_group("enemies"))
#			if body.is_in_group("enemies"):
#				if body.get_node("CollisionShape2D").disabled == false:
#					bullet.can_hit = false
#					$CollisionShape2D.set_deferred("disabled", true)
#					enemy_hit(body)
#					get_parent().queue_free()

#			get_parent().queue_free()
