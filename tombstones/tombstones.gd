extends Node2D
@export var tombstones: Array = [
	"res://tombstones/tombstone_bird.tscn",
	"res://tombstones/tombstone_hammer.tscn",
	"res://tombstones/tombstone_lava.tscn"
]
var current_tombstone: Tombstone = null


func _ready() -> void:
	for i in range(10):
		var tombstone = _new_tombstone()
		tombstone.position.x += i*500
	setup_current_tombstone()

func _process(delta: float) -> void:
	pass


func next():
	var old = get_children()[0]
	old.queue_free()
	var tombstone = _new_tombstone()
	tombstone.position.x += get_child_count()*500
	
	for child in get_children():
		child.position.x -= 500
	await old.tree_exited 
	setup_current_tombstone()
	
func setup_current_tombstone():
	current_tombstone = get_children()[0]
	current_tombstone.get_node("ClickDetection").process_mode = Node.PROCESS_MODE_INHERIT

func _new_tombstone() -> Tombstone:
	var tombstone = load(tombstones.pick_random()).instantiate()
	add_child(tombstone)
	return tombstone
