extends StaticBody2D

# Signals
signal get_hit

export var hit_points = 1 setget set_hp, get_hp
var max_hp = 10
var barricade_down = false

var barricade_group_name = "barricade"
var enemies_group_name = "enemies"


func _ready() -> void:
#	hit_points = 1
	hit_points = max_hp
	pass


func set_hp(new_hp):
	hit_points = new_hp
	print(hit_points)
	
	if hit_points <= 0: # Barricade has been destroyed
#		print("Barricade has been destroyed")
		barricade_down = true
		$Sprite.visible = false
#		print(get_collision_mask_bit(1))
#		set_collision_mask_bit(1, false) #-----------------------------------
	else: # Barricade still has more than 0 hp
		print("Barricade UP!!!!!!!!!!!!!!!!!!!")
		barricade_down = false
		if get_node("Sprite"):
			$Sprite.visible = true
#			set_collision_mask_bit(1, true)# ------------------------------
#		print(get_collision_mask_bit(1))
	

func get_hp():
#	print("Barricade health: " + str(hit_points))
	return hit_points
	pass


# Fired when shot by player (DEBUG)
func _on_Area2D_body_entered(body: Node) -> void:
#	print(body.get_instance_id())
#	print(body.get_collision_mask_bit(3))
#	print(body.get_collision_layer_bit(3))
	if body.get_collision_layer_bit(3):
#		print(body.get_collision_layer_bit(3))
		self.hit_points -= body.damage

# Fired when an enemy enters it (Surefire way to know the enemy is inside the arena, passed the barricade)
func _on_InsideAreaTrigger_body_entered(body: Node) -> void:
	if body.get_collision_layer_bit(1): # If it's an enemy
		body.inside_arena = true



#func _on_Barricade_has_been_hit(damage) -> void:
#	self.hit_points -= damage


func _on_Barricade_get_hit(damage) -> void:
	# Remove hit_points from the barricade, based on how much damage was dealt
	self.hit_points -= damage
	print("Barricade hp: " + str(hit_points))
#	if hit_points <= 0:
#		on_death()


