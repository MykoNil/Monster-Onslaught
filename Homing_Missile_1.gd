extends KinematicBody2D
#extends Area2D
#extends RigidBody2D

# NOT GONNA DO ANYTHING TO THIS UNTIL I SET UP A BASE BULLET NODE

#var flight_dir = Vector2.ZERO
export var damage = 2
export var speed = 250
var target = null
var player_node

var can_hit = true

var move_direction = Vector2.ZERO
var velocity = Vector2.UP
var rot_velocity = Vector2.ZERO

var default_rotate_speed = 5
var rotate_speed = default_rotate_speed
var max_rotate_speed = 25



func _ready() -> void:
#	target = get_node("../Player")
	player_node = get_node("../Player")
	find_target()
	pass

func init(start_position, direction):
	move_direction = direction
	position = start_position
	rotation = move_direction.angle() + deg2rad(90)

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	var new_target = null
	var previous_distance = null
	var chosen_enemy = null
	
	for enemy in enemies:
		var distance_from_player = (enemy.position - player_node.position).length()
		if enemy.hit_points > 0:
			if not previous_distance:
				previous_distance = distance_from_player
				chosen_enemy = enemy
			else:
				if distance_from_player < previous_distance:
					previous_distance = distance_from_player
					chosen_enemy = enemy
	
	if chosen_enemy:
		target = chosen_enemy
	else:
		target = null



func _physics_process(delta: float) -> void:
	var direction = move_direction
	var distance = direction.length()
	
	if is_instance_valid(target): # If there's no target, fly straight in direction of shot.
		if target.hit_points < 0:
			target = null
			find_target()
		else:
#			print(target)
			direction = target.position - position
			
	else:
		find_target()
		
	
	if distance <= 200:
		if rotate_speed < max_rotate_speed:
			rotate_speed += 0.125# 4 + 200 / distance
	else:
		rotate_speed = default_rotate_speed
		
#	print(rotate_speed)
	var collide_info = move_and_collide(velocity)
	direction = direction.normalized()
	
	var rotate_amount = direction.cross(-global_transform.y)
	
	rot_velocity = -rotate_amount * rotate_speed * delta
	velocity = -global_transform.y * speed * delta
	
	rotation += rot_velocity
	
	if collide_info:
		velocity = Vector2.ZERO
#	position += velocity


# Destroys the bullet after a certain amount of time
func _on_Lifetime_timeout() -> void:
	queue_free()



