extends CanvasLayer

signal show_main

# Called when the node enters the scene tree for the first time.
func _ready():
	show_how_to_play(false)

func show_how_to_play(show: bool = true):
	var children = self.get_children()
	for child in children:
		if show:
			child.show()
		else:
			child.hide()

func return_to_main():
	show_how_to_play(false)
	emit_signal("show_main")
