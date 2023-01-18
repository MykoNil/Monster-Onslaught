extends TextureRect

# This script will handle all of the status effect's animations
var animation_play_counter = 0
var animation_gap_time = 80
var rng = RandomNumberGenerator.new()
var new_random_gap_time = 0

var animated_sprite

func _ready():
	randomize()
	new_random_gap_time = get_new_random_gap_time(animation_gap_time)
	
	animated_sprite = $AnimatedSprite
	
# Take the base animation_gap_time and randomize wait time to between -20 & +20 of it
func get_new_random_gap_time(gap_time):
	return rng.randi_range(gap_time - 10, gap_time + 60)

func _process(delta):
	
	if animation_play_counter >= new_random_gap_time: # Timer is done
		new_random_gap_time = get_new_random_gap_time(animation_gap_time) # Reset the random time (For next gap)
		animation_play_counter = 0 # Reset the timer counter
		
		# Now play the animation
		animated_sprite.frame = 0
		animated_sprite.play()
	
	animation_play_counter += 1

