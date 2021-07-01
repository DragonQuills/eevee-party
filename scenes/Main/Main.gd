extends Node

export var tile_size = 24 * 2 #since the tiles were scaled up
export var speed = 4
var item_spawn_speed = 9/speed

onready var Item = load("res://scenes/Item/Item.tscn")
onready var Snake = load("res://scenes/Snake/Snake.tscn")
onready var GameOverSound: AudioStream = load("res://assets/sound_effects/game_over.wav")
onready var PickUpSound: AudioStream = load("res://assets/sound_effects/pick_up.wav")
onready var GrimyPickUpSound: AudioStream = load("res://assets/sound_effects/grimy_pick_up.wav")
onready var ApplePickUpSound: AudioStream = load("res://assets/sound_effects/apple_pick_up.wav")

onready var item_sounds = {
	"normal": PickUpSound,
	"grimy": GrimyPickUpSound,
	"apple": ApplePickUpSound
}

onready var items = []

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_distance(p1: Vector2, p2: Vector2):
	return sqrt( pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2) )

func close_to_anything(pos):
	for item in items:
		var distance = get_distance(item.position, pos)
		if distance < 30:
			return true
	return false

func spawn_item(spawn_position: Vector2):	
	var item = Item.instance()
	item.randomize_item_type(rng)
	item.position = spawn_position
	items.append(item)
	$ItemsContainer.add_child(item)

func get_spawn_position():
	var x = rng.randf_range($TopLeft.position.x, $BottomRight.position.x)
	var y = rng.randf_range($TopLeft.position.y, $BottomRight.position.y)
	var spawn_position = Vector2(x,y)
	spawn_position = spawn_position.snapped(Vector2.ONE * tile_size)
	spawn_position += Vector2.ONE * tile_size/2
	if close_to_anything(spawn_position):
		spawn_position = get_spawn_position()
	return spawn_position

func start():
	speed = 4
	
	var snake = Snake.instance()
	snake.set_position($StartPosition.position)
	items.append(snake)
	snake.set_speed(speed)
	snake.connect("item_collected", self, "_on_Snake_item_collected")
	snake.connect("hit", self, "_on_Snake_hit")
	self.add_child(snake)
	
	spawn_item(get_spawn_position())
	spawn_item(get_spawn_position())
	spawn_item(get_spawn_position())
	
	$ItemSpawnTimer.start(9/speed)
	$SpeedUpTimer.start()
	
	$HUD.show_score()
	
func game_over():
	$Snake.stop()
	$HUD.show_game_over()
	$ItemSpawnTimer.stop()
	$SpeedUpTimer.stop()
	
	$SoundEffects.stop()
	$SoundEffects.stream = GameOverSound
	$SoundEffects.play()
	
	yield(get_tree().create_timer(3), "timeout")
	for item in items:
		item.queue_free()
	items = []
	$HUD.show_game_over(false)
	$HUD.reset_score()
	$HUD.show_score(false)
	$MainMenu.show_main()

func _on_Snake_hit():
	game_over()

func _on_ItemSpawnTimer_timeout():
	spawn_item(get_spawn_position())
	$ItemSpawnTimer.start(item_spawn_speed)

func _on_Snake_item_collected(item):
	$HUD.update_score(item.points())
	
	$SoundEffects.stream = item_sounds[item.item_type]
	$SoundEffects.play()

func _on_MainMenu_start():
	start()

func _on_SpeedUpTimer_timeout():
	speed += 0.05
	$Snake.set_speed(speed)
	item_spawn_speed = 9/speed
	if speed < 9:
		$SpeedUpTimer.start(1)
