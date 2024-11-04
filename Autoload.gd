extends Node

func _ready():
	if OS.has_feature("template"):
		print("Running an exported build.")
		Engine.max_fps = 144
		print("FPS is limited to 144")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("Vsync is disabled")
	else:
		print("Running from the editor.")
		Engine.max_fps = 144
		print("FPS is limited to 144")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("Vsync is disabled")
		
		
