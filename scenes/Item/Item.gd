extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func randomize_item_type(rng):
	var rand_float = rng.randf()
	# Special
	if rand_float > 0.8:
		$ItemSprite.animation = "special"
		$ItemSprite.frame = rng.randi_range(0, $ItemSprite.frames.get_frame_count("special") - 1)
	else:
		$ItemSprite.animation = "normal"
		$ItemSprite.frame = rng.randi_range(0, $ItemSprite.frames.get_frame_count("normal") - 1)
		
func move(new_pos, tween, speed):
	tween.interpolate_property(self, "position",
			position, new_pos,
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func points():
	if $ItemSprite.animation == "special" and $ItemSprite.frame == 0:
		return 50
	elif $ItemSprite.animation == "special" and $ItemSprite.frame == 1:
		return -50
	else:
		return 20
