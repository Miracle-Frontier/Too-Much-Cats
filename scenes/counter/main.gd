extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
