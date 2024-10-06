extends Node2D

@export var scene_list: Array[PackedScene] = []

var difficulty = 1
var is_fast: bool = false
var time_to_complete = 10
var spawn_amount = 3 # Так же сам дисплей ускоряется, который показывает эти штуки
var memorize = 1
var speed = 170.0

func _ready() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	var excluded_scene = "counter_item.tscn"
	
	var distance = 0
	var previous_item
	for i in range(spawn_amount):
		print("zalypa")
		var item = scene_list[randi() % scene_list.size()].instantiate()
		$Items.add_child(item)
		item.position = $Spawnpoint.position
		if previous_item:
			distance += previous_item.get_node("Sprite2D").texture.get_size().x + (randi() % 900)
		item.position.x += distance
		item.position.y += -70 + (randi() % 180)
		previous_item = item
	$Parallax2D.autoscroll.x = -speed
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for item in $Items.get_children():
		item.position.x -= speed * delta
