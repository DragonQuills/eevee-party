extends CanvasLayer

signal start

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide_all():
	show_main(false)
	show_help(false)

func show_main(show: bool = true):
	var main_menu_items = $Main.get_children()
	for item in main_menu_items:
		if show:
			item.show()
		else:
			item.hide()

func show_help(show: bool = true):
	var help_items = $Help.get_children()
	for item in help_items:
		if show:
			item.show()
		else:
			item.hide()


func _on_QuitButton_pressed():
	get_tree().quit() # default behavior


func _on_StartButton_pressed():
	hide_all()
	emit_signal("start")
