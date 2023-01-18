extends KinematicBody2D


export var damage = 0
export var speed = 620
var pierce = 0

var move_direction = Vector2.ZERO
var velocity = Vector2.ZERO

var can_hit = true
var bullet

var hit_particle_emitter
var bullet_can_be_destroyed = false
var ready_to_destroy_bullet = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet = self
	set_physics_process(true)
	
	hit_particle_emitter = $CPUParticles2D


func init(start_position, direction):
	move_direction = direction
	position = start_position
	rotation = move_direction.angle() + deg2rad(90)


func _physics_process(delta: float) -> void:
	if move_direction:
		var collide_info = move_and_collide(velocity * delta)#velocity = move_and_slide(velocity)
		move_direction = move_direction.normalized()
		rotation = move_direction.angle() + deg2rad(90)
		velocity = -global_transform.y * speed# * delta
		
		if collide_info:
			velocity = Vector2.ZERO
#			print(collide_info.collider.get_collision_layer_bit(2))
			if collide_info.collider.get_collision_layer_bit(2):
				bullet_blow_up()
#			move_direction = Vector2.ZERO
#			velocity = -velocity#Vector2.ZERO
#			move_direction = move_direction.reflect(collide_info.remainder)
#			var reflect = collide_info.remainder.bounce(collide_info.normal)
#			move_direction = move_direction.bounce(collide_info.normal)
#			move_and_collide(reflect)
#		print(get_slide_collision(0))
	
	if ready_to_destroy_bullet:
		if not hit_particle_emitter.emitting:
			bullet_can_be_destroyed = true
	if bullet_can_be_destroyed:
		queue_free()
		




func bullet_blow_up():
	# Do some sort of particle effect showing the bullet was destroyed
#	queue_free()
	move_direction = Vector2(0, 0)
	hit_particle_emitter.restart()
	$Sprite.visible = false
#	hit_particle_emitter.emitting = true
	ready_to_destroy_bullet = true



# Destroys the bullet after a certain amount of time
func _on_Lifetime_timeout() -> void:
	queue_free()


func enemy_hit(body):
#	print("srfjlesakfja;skidjf;oeijs;lkef;olsijef;lkse;sk")
#	print("bullet " + str(body.get_instance_id()) + " damage: " + str(bullet.damage)) # For checking what was hit
	if bullet:
		body.emit_signal("get_hit", bullet.damage, bullet.pierce)

func _on_HitDetector_body_entered(body: Node) -> void:
	#	print(body.get_instance_id())
	if bullet:
		if bullet.can_hit:
			if body.is_in_group("enemies"):
				if body.get_node("CollisionShape2D").disabled == false:
					bullet.can_hit = false
					$CollisionShape2D.set_deferred("disabled", true)
					enemy_hit(body)
					bullet_blow_up()
