extends Node2D
var tombstone_scene = preload("res://tombstone.tscn")
var current_tombstone: Tombstone = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		var tombstone = tombstone_scene.instantiate()
		add_child(tombstone)
		tombstone.position.x += i*500
	setup_current_tombstone()

func _process(delta: float) -> void:
	pass

func next():
	var old = get_children()[0]
	old.queue_free()
	var tombstone = tombstone_scene.instantiate()
	tombstone.position.x += get_child_count()*500
	add_child(tombstone)
	for child in get_children():
		child.position.x -= 500
	await old.tree_exited 
	setup_current_tombstone()
	
func setup_current_tombstone():
	current_tombstone = get_children()[0]
	current_tombstone.get_node("ClickDetection").process_mode = Node.PROCESS_MODE_INHERIT
