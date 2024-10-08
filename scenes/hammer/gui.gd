extends Control


var tween: Tween = null;
@onready var start_reward_position: Vector2 = $Reward.position;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Reward.modulate.a = 0;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_gameplay_coins_updated(new_value: Variant) -> void:
	$Debug/coins_v.text = str(new_value);


func _on_gameplay_stage_updated(new_stage: Variant) -> void:
	$Debug/step_v.text = str(new_stage);


func _on_gameplay_last_hit_rotate_update(new_rotate: Variant) -> void:
	$Debug/rotate_v.text = str(new_rotate);


# Анимация появления текста с наградой
func _on_gameplay_reward_show(count: Variant, precent: float) -> void:
	$Reward.position.y = start_reward_position.y;
	$Reward.modulate.a = 0;
	$Reward.text = "%d монеток\n%d%%" % [count, int(precent * 100)]
	get_tween().tween_property($Reward, "position:y", $Reward.position.y - 100, 1).set_trans(Tween.TRANS_EXPO);
	get_tween().tween_property($Reward, "modulate:a", 1, 0.9).set_delay(0.2);
	get_tween().tween_property($Reward, "modulate:a", 0, 0.2).set_delay(1);

# Вернуть аниматор или сделать его, если он отсутствует
func get_tween() -> Tween:
	return create_tween();
