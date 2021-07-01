extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

onready var item_type


func randomize_item_type(rng):
	var rand_float = rng.randf()
	print(rand_float)
	# Special
	if rand_float > 0.9:
		item_type = "apple"
		$ItemSprite.animation = "special"
		$ItemSprite.frame = 0
	elif rand_float >= 0.8 and rand_float < 0.9:
		item_type = "grimy"
		$ItemSprite.animation = "special"
		$ItemSprite.frame = 1
	else:
		item_type = "normal"
		$ItemSprite.animation = "normal"
		$ItemSprite.frame = rng.randi_range(0, $ItemSprite.frames.get_frame_count("normal") - 1)
		
func move(new_pos, tween, speed):
	tween.interpolate_property(self, "position",
			position, new_pos,
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func points():
	if item_type == "apple":
		return 50
	elif item_type == "grimy":
		return -50
	else:
		return 20
