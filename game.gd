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
	$Tombstones.next()
	difficulty+=1

func _on_difficulty_changed(val):
	print("diff increased")
	%RichTextLabel.visible = true
	difficulty = int(val)
	%RichTextLabel.text = str(difficulty)
