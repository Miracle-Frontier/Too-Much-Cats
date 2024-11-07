extends Node2D


@onready var head = $SkeletHead;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sway();


func sway():
	var move_distance = 100;
	var tween = create_tween();
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
