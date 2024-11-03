extends Node2D

class_name Game

var coins = 0
var lives = 3
var difficulty = 0

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func next_tombstone():
	$Tombstones.next()
	%RichTextLabel.visible = true
	difficulty = int(%RichTextLabel.text)+1
	%RichTextLabel.text = str(difficulty)
