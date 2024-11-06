extends Node2D

var platform_scene = load("res://scenes/lavalevel/platform.tscn")

var GENERATION_HEIGHT = 10000 # Total level height
var y_gap_between_platforms = [300, 600]
var FINISH_LINE_HEIGHT = 7000 # Finish line
var generation_x_limits = [-900, 900] # x-axis limits for platform spawning

func _ready() -> void:
	var i=0
	while i>-GENERATION_HEIGHT:
		i-=randf_range(y_gap_between_platforms[0], y_gap_between_platforms[1])
		var platform = platform_scene.instantiate()
		add_child(platform)
		platform.position.x = randf_range(generation_x_limits[0], generation_x_limits[1])
		platform.position.y = i

#@onready var offset_left = $Left.position.y - $Hero.position.y
#@onready var offset_right = $Right.position.y - $Hero.position.y

func _process(delta: float) -> void:
	print($Hero.position.y)
	if $Hero.position.y <= -FINISH_LINE_HEIGHT:
		end_level()
		var game: Game = get_tree().current_scene
		game.next()
func end_level(): # gets called if reached finish line
	queue_free()


func _on_left_bttn_pressed() -> void:
	pass # Replace with function body.


func _on_right_bttn_released() -> void:
	pass # Replace with function body.
