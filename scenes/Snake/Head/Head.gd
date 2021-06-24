extends Area2D

signal hit

export var tile_size = 24 * 2 #since the tiles were scaled up

onready var ray = $RayCast2D

var direction = "ui_down"

# used to map the directions the player can move
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func move(dir, tween, speed):	
	# update the animation for the new direction
	if dir == "ui_up":
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = false
	elif dir == "ui_down":
		$AnimatedSprite.animation = "down"
		$AnimatedSprite.flip_h = false
	elif dir == "ui_left":
		$AnimatedSprite.animation = "side"
		$AnimatedSprite.flip_h = false
	elif dir == "ui_right":
		$AnimatedSprite.animation = "side"
		$AnimatedSprite.flip_h = true
	
	# check if we're trying to move somewhere valid
	ray.cast_to = inputs[dir] * tile_size/2
	ray.force_raycast_update()
	if !ray.is_colliding():
		# move between the squares
		tween.interpolate_property(self, "position",
			position, position + inputs[dir] * tile_size,
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		$AnimatedSprite.play()		
	else:
		emit_signal("hit")

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.stop()

func hurt():
	var animation = "hurt_" + str($AnimatedSprite.animation)
	$AnimatedSprite.animation = animation
