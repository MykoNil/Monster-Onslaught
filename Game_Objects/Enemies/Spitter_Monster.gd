extends "res://Game_Objects/Enemies/Enemy_Parent_Scene.gd"

# Maybe put these in a separate node, perhaps a "status effect" handler or manager
var status_effect_poison_name = "Poison"
var spit_acid_scene = preload("res://Game_Objects/Projectiles/Enemy Projectiles/Acid_Spit.tscn")

var projectile_fire_rate = 3 #(Seconds)
var projectile_status_effect = status_effect_poison_name

var spitter_mouth_node
var mouth_tip_node
var arena_node
var can_attack = true
var animation_done = true

var attack_cooldown_timer_node
var attack_cooldown = 2

var attack_spitter_anim_name = "Spitter_Attack"
var old_anim


func _ready():
	hit_points = 75
	damage = 4
	attack_range = 275
	
	walk_speed = 90
	
	cash_value = 10
	
	.randomize_walk_speed()
	
	# Setting up its weaknesses & strengths
	damage_effectors = {
		"weaknesses": {
			"fire": 0.1,
			"ice": 0.25
		},
		"strengths": {
			"explosion": 0.15
		}
	}
	
	spitter_mouth_node = get_node("Body/Head/Mouth")
	mouth_tip_node = spitter_mouth_node.get_node("Position2D")
	arena_node = get_node("..")
	
	attack_cooldown_timer_node = get_node("AttackCooldownTimer")
	
	melee_attacker = false


func _physics_process(delta):
	if can_move:
		var distance_from_target = (target.global_position - global_position).length()
	#	if distance_from_target <= attack_range:
	#		if not can_attack:
	#			animation_player.play("RESET")
	#	var new_anim = animation_player.get_current_animation()
	#	if new_anim != old_anim:
	#		#Animation changed
	#		if new_anim != attack_spitter_anim_name:
	#			pass
	#	if old_anim:
	#		if animation_player.get_current_animation_position() >= animation_player.get_current_animation().length():
	#			print(animation_player.get_current_animation_position())
	#			animation_done = true
		if state == states[1]: # Walking?
			animation_done = true
		elif state == states[2]: # Attacking
			if can_attack:
					change_anim(attack_spitter_anim_name, 1.5)
					old_anim = animation_player.get_animation(animation_player.get_current_animation())
	#				animation_interrupted = false
					animation_done = false
			else:
				if animation_done:
					animation_player.play("RESET")


# Activate attack
func attack_target():
	if target:
		spit_projectile()
		can_attack = false
		animation_done = false
		attack_cooldown_timer_node.start(attack_cooldown)
#		target.emit_signal("get_hit", attack_damage)

# Shoot a ball of acid toward the player
func spit_projectile():
	# Instantiates a bullet from the given bullet scene and sets its direction
	var bullet = spit_acid_scene.instance()
	var shot_direction = target.global_position - global_position
	bullet.init(mouth_tip_node.global_position, shot_direction)
	arena_node.add_child(bullet)


# Check if the enemy's attack animation has finished, then play the next randomized attack animation
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
#	print("Test")

	if anim_name == "flinch":
		can_move = true
	
	var distance_from_target = (target.global_position - global_position).length()
	if distance_from_target > attack_range: # Player is now out of range
		attacking = false # Cancel attacking
	
#	if anim_name == attack_spitter_anim_name:

# Prevent enemy from animation cancelling its attacks
func _on_AttackCooldownTimer_timeout() -> void:
	can_attack = true

## Prevent the enemy from doing walk animation even when standing still
#func _on_AnimationPlayer_animation_changed(old_name: String, new_name: String) -> void:
#	print(old_name)
#	print(new_name)
#	if old_name == attack_spitter_anim_name and new_name == "Walk":
#		animation_done = true
