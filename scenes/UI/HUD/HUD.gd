extends CanvasLayer

onready var score = 0

func _ready():
	$ScoreLabel.hide()
	$GameOverLabel.hide()

func update_score(pts):
	score += pts
	$ScoreLabel.text = str(score)
	if pts < 0: # If score went down
		var old_color = $ScoreLabel.get_color("font_color")
		$ScoreLabel.add_color_override("font_color", Color("ff0000"))
		# Make a temp timer and wait for it to timeout
		yield(get_tree().create_timer((0.5)), "timeout")
		$ScoreLabel.add_color_override("font_color", old_color)
	elif pts > 20: # If we got a large scroe boost
		var old_color = $ScoreLabel.get_color("font_color")
		$ScoreLabel.add_color_override("font_color", Color("50ff00"))
		# Make a temp timer and wait for it to timeout
		yield(get_tree().create_timer((0.5)), "timeout")
		$ScoreLabel.add_color_override("font_color", old_color)

func reset_score():
	score = 0
	$ScoreLabel.text = str(score)

func show_score(show: bool = true):
	if show:
		$ScoreLabel.show()
	else:
		$ScoreLabel.hide()

func show_game_over(show: bool = true):
	if show:
		$GameOverLabel.show()
	else:
		$GameOverLabel.hide()
