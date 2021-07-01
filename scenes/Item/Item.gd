extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

onready var type


func randomize_item_type(rng):
	var rand_float = rng.randf()
	if rand_float > 0.9:
		type = "apple"
		$ItemSprite.animation = "special"
		$ItemSprite.frame = 0
	elif rand_float >= 0.8 and rand_float < 0.9:
		type = "grimy"
		$ItemSprite.animation = "special"
		$ItemSprite.frame = 1
	else:
		type = "normal"
		$ItemSprite.animation = "normal"
		$ItemSprite.frame = rng.randi_range(0, $ItemSprite.frames.get_frame_count("normal") - 1)
		
func move(new_pos, tween, speed):
	tween.interpolate_property(self, "position",
			position, new_pos,
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func points():
	if type == "apple":
		return 50
	elif type == "grimy":
		return -50
	else:
		return 20
