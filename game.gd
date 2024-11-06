extends Node2D

class_name Game

var coins = 0
var lives = 3
var difficulty = 0 : set = _on_difficulty_changed

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func next():
	var anim: AnimationPlayer = $AnimationPlayer
	anim.play("next")
	#$Tombstones.next()
	difficulty+=1

func _tween_stuff():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Tombstones,"position",Vector2($Tombstones.position.x-800,$Tombstones.position.y),0.6)
	tween.parallel().tween_property($Ground,"scroll_offset",Vector2($Ground.scroll_offset.x-800,$Ground.scroll_offset.y),0.6)
	tween.parallel().tween_property($Deco,"scroll_offset",Vector2($Deco.scroll_offset.x-180,$Deco.scroll_offset.y),0.6)
	tween.parallel().tween_property($Deco2,"scroll_offset",Vector2($Deco2.scroll_offset.x-70,$Deco2.scroll_offset.y),0.6)
	tween.parallel().tween_property($Moon,"scroll_offset",Vector2($Moon.scroll_offset.x-30,$Moon.scroll_offset.y),0.6)
func _on_difficulty_changed(val):
	%RichTextLabel.visible = true
	difficulty = int(val)
	%RichTextLabel.text = str(difficulty)
