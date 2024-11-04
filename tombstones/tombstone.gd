extends Node2D

class_name Tombstone

@export var scene = load("res://scenes/hammer/hammer.tscn")

func _ready() -> void:
	#get_parent().next()
	pass
	

func _process(delta: float) -> void:
	pass

func _on_click_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_released()):
		get_tree().current_scene.add_child(scene.instantiate())