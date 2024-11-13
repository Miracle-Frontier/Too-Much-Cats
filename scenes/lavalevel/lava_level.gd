extends Node2D

# PLATFORM 2 JUMP ONLY 
# BUY NEW DIFFICULTIES
# TODO MOVING PLATFORMS
# INCREASES CAMERA SHAKING  (LIMIT!!!!!!)
# МУЗЫКА УСКОРЯЕТСЯ ( LIMIT!!!!!)
# AMOUNT OF PLATFORMS
# ЗВУКИ ВОЗДУХА ПРИ ПАДЕНИИ И ПОДЪЕМА
var platform_scene = load("res://scenes/lavalevel/platform.tscn")

var generation_height = 10000 # Total level height
var y_gap_between_platforms = [300, 600]
var finish_line_height = null # Finish line
var generation_x_limits = [-900, 900] # x-axis limits for platform spawning
var is_moving = false
@onready var hero = $Hero
@onready var game = Autoload.game
func _ready() -> void:
	hero.speed_y_modifier = game.difficulty+2
	generation_height = hero.jump_height*(game.difficulty+1)
	finish_line_height = generation_height+hero.jump_height/2
	var i=0
	while i>-generation_height:
		i-=hero.jump_height-5#randf_range(y_gap_between_platforms[0], y_gap_between_platforms[1])
		var platform = platform_scene.instantiate()
		add_child(platform)
		platform.position.x = randf_range(generation_x_limits[0], generation_x_limits[1])
		platform.position.y = i

#@onready var offset_left = $Left.position.y - $Hero.position.y
#@onready var offset_right = $Right.position.y - $Hero.position.y

func _physics_process(delta: float) -> void:
	if $Hero.position.y <= -finish_line_height:
		end_level()
	
@onready var shake_intensity: float = 100.0 + game.difficulty * 100  # Теперь амплитуда ограничена 100
var shake_speed: float = 20.0
var time: float = 0.0
var noise = FastNoiseLite.new()

func _process(delta: float) -> void:
	time += delta * shake_speed
	var shake_x = noise.get_noise_1d(time) * shake_intensity
	var shake_y = noise.get_noise_1d(time + 1000.0) * shake_intensity
	$Hero/Camera2D.offset = Vector2(shake_x, shake_y)
		
func end_level(): # gets called if reached finish line
	Autoload.return_to_saved_scene()
	Autoload.game.next()

func _on_left_bttn_pressed() -> void:
	pass # Replace with function body.


func _on_right_bttn_released() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	end_level()
