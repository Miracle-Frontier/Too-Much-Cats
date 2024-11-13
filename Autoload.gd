extends Node

var game: Game: get = _get_game
var saved_scene

func switch_scene(switch_to_scene: Node):
	saved_scene = get_tree().current_scene
	get_node("/root/").remove_child(saved_scene)
	get_node("/root/").add_child(switch_to_scene)
	get_tree().current_scene = switch_to_scene
func return_to_saved_scene(save_current=false):
	if not save_current: get_tree().current_scene.queue_free()
	get_tree().root.add_child(saved_scene)
	get_tree().current_scene = saved_scene

func _ready():
	if OS.has_feature("template"):
		print_rich("[color=green][b]Running an exported build")
		_enable_vsync_mailbox()
	else:
		print_rich("[color=green][b]Running from the editor")
		_enable_vsync_mailbox()
		
func _enable_vsync_mailbox():
	Engine.max_fps = 0 # Убирает ограничение на FPS. Необходимо на случай VSYNC_DISABLED, в другом случае игнорируется, т.к VSYNC
	# TODO: ВАЖНО ДОБАВИТЬ ТУТ НАСТРОЙКУ VSYNC в меню настроек в самой игре, которая будет это overrideить, потому что screen tearing возможен при VSYNC_DISABLED у некоторых игроков.
	# TODO: ВАЖНО ДОБАВИТЬ НАСТРОЙКУ LIMIT FPS в меню, которая так же будет это оверрайдить
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	if (DisplayServer.window_get_vsync_mode()!=3):
		print_rich("[color=yellow][b]WARNING!!! WARNING!!!!\nVsync MAILBOX mode WAS DISABLED.\nMAKE SURE THIS IS NOT A BUILD FOR LAPTOP WITH EXTERNAL DISPLAY AND OPTIMUS CHIP\nCURRENT VSYNC MODE IS "+str(DisplayServer.window_get_vsync_mode()))
		if (DisplayServer.window_get_vsync_mode()==1):
			print_rich("[color=green][b]Disabling vsync without MAILBOX (must be overrideable in desktop build to prevent tearing for some players)")
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		print_rich("[color=green][b]Vsync MAILBOX is enabled")

var _game_scene = preload("res://Game.tscn")

func _get_game() -> Game:
	if (not game): 
		print_rich("[color=red][b]GAME IS NOT INSTANTIATED!!! Instancing it now...")
		game = _game_scene.instantiate()
		saved_scene = game
	return game
