extends Node2D
@export var tombstones: Array = [
	"res://tombstones/tombstone_bird.tscn",
	"res://tombstones/tombstone_hammer.tscn",
	"res://tombstones/tombstone_lava.tscn"
]
var current_tombstone: Tombstone = null
var last_tombstone_spawn_position
@onready var game: Game = get_tree().current_scene


func _ready() -> void:
	for i in range(4):
		var tombstone = _new_tombstone()
		last_tombstone_spawn_position = i*800
		tombstone.position.x += last_tombstone_spawn_position
		
	current_tombstone = get_children()[0]
	_setup_current_tombstone()

func _process(delta: float) -> void:
	pass


func next():
	var old = get_children()[0]
	old.queue_free()
	var new_tombstone = _new_tombstone()
	current_tombstone = get_children()[1]
	_setup_current_tombstone()
	last_tombstone_spawn_position += 800
	new_tombstone.position.x = last_tombstone_spawn_position
	#for child in get_children():
	#	child.position.x -= 800

func _setup_current_tombstone():
	current_tombstone.get_node("ClickDetection").process_mode = Node.PROCESS_MODE_INHERIT

func _new_tombstone() -> Tombstone:
	var tombstone = load(tombstones.pick_random()).instantiate()
	add_child(tombstone)
	return tombstone
