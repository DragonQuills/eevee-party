extends Node

# Tile size in px used for centering things on the tile
export var tile_size = 24 * 2 
export onready var position: Vector2 = $Head.position

signal hit
signal item_collected(item)

onready var tween = $Tween

# Direction the player is facing
var direction = "ui_down"
var speed = 1

# Whether the player has just picked up an item
var just_picked_up = false

# Used to map the directions the player can move
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}


### General ###
func set_speed(spd):
	speed = spd


### Tail Modifications ###
func add_to_tail(tail_segment):
	var old_parent = tail_segment.get_parent()
	old_parent.remove_child(tail_segment)
	tail_segment.name="Tail"
	$TailContainer.call_deferred("add_child", tail_segment)
	just_picked_up = true



### Movement ###
func set_position(pos):
	$Head.set_position(pos)

func _input(event):
	# catch inputs so we can move that way
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			# Player isn't allowed to turn opposite direction
			if inputs[dir] + inputs[direction] != Vector2.ZERO:
				direction = dir
	
func move_tail(head_pos):
	var full_tail = $TailContainer.get_children()
	var new_pos = head_pos
	full_tail.invert()
	for tail_segment in full_tail:
		var temp_next_pos = tail_segment.position
		tail_segment.move(new_pos, tween, speed)
		new_pos = temp_next_pos
		tail_segment.set_collision_layer_bit(0, true)
		tail_segment.set_collision_layer_bit(1, false)

func stop():
	$MoveTimer.stop()
	$Head.hurt()


### Signals ###
func _on_MoveTimer_timeout():
	if not tween.is_active():
		var head_pos = $Head.position
		$Head.move(direction, tween, speed)
		if just_picked_up:
			just_picked_up = false
		else:
			move_tail(head_pos)

func _on_Head_hit():
	emit_signal("hit")

func _on_Head_area_entered(area):
	if "Item" in area.name:
		add_to_tail(area)
		emit_signal("item_collected", area)
