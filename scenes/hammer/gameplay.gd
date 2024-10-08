extends Node2D

signal coins_updated(new_value);
signal stage_updated(new_stage);
signal last_hit_rotate_update(new_rotate);
signal reward_show(count, precent);

var is_can_parry: bool = true;  # Может ли игрок использовать вентилятор 
var coins: int = 0;  # Текущее количество монет
var coins_perfect_reward: int = 30;  # Награда за хороший удар
var coins_loose: int = 20;  # Потеря при промахе
var current_stage: Stage = Stage.SHIFT_CLIENT;  # Текущая стадия игры
var tween: Tween = null;  # Аниматор удара
var last_rotation = 0;  # Информация о последнем зафиксированном градусе парирования

@onready var timer_shift_client = $TimerShiftClient;  # Время смены клиента
@onready var timer_swing = $TimerSwing;  # Время замаха молотком
@onready var timer_hit = $TimerHit;  # Время удара
@onready var hammer = $Scene/Hammer  # Молот


# Все стадии игры
enum Stage {
	SHIFT_CLIENT = 0,  # Смена клиента
	SWING = 1,  # Замах
	HIT = 2,  # Удар
}


func _ready() -> void:
	timer_shift_client.wait_time = 2.0;
	timer_shift_client.start();


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if current_stage == Stage.SWING and is_can_parry:
			# Анимация переключателя
			$Scene/Controller/ClickerOff.visible = false;
			$Scene/Controller/ClickerOn.visible = true;
			$Scene/Coffin/VentOff.visible = false;
			$Scene/Coffin/VentOn.visible = true;
			
			# Определение замедления (чем ближе замах к середите - тем лучше)
			if -45 > hammer.rotation_degrees or hammer.rotation_degrees > 45:
				# Слишком рано или поздно
				update_coins(coins - coins_loose);
				emit_signal("reward_show", -coins_loose, 0)
			else:
				# Расчет попадания
				var precent: float = (1 - abs(hammer.rotation_degrees) / 90) ** 2;
				var reward: int = int(precent * coins_perfect_reward);
				update_coins(coins + reward);
				update_last_hit_rotate(precent);
				emit_signal("reward_show", reward, precent);
			is_can_parry = false;

	if Input.is_action_just_released("click"):
		# Анмиация переключателя
		$Scene/Controller/ClickerOff.visible = true;
		$Scene/Controller/ClickerOn.visible = false;
		$Scene/Coffin/VentOff.visible = true;
		$Scene/Coffin/VentOn.visible = false;


# Обновление количества денег, передача сигнала
func update_coins(new_value: int) -> void:
	coins = new_value;
	emit_signal("coins_updated", coins);


# Обновление стадии игры, передача сигнала
func update_stage(new_stage: Stage) -> void:
	current_stage = new_stage;
	emit_signal("stage_updated", current_stage);


# Обновление информации о последнем угле
func update_last_hit_rotate(new_rotate) -> void:
	last_rotation = new_rotate;
	emit_signal("last_hit_rotate_update", new_rotate);


# Клиент был сменен, время замаха
func _on_timer_shift_client_timeout() -> void:
	var hit_time = randf_range(0.5, 1);
	is_can_parry = true;
	timer_swing.wait_time = hit_time
	timer_swing.start();
	update_stage(Stage.SWING);
	hammer.rotation_degrees = -90;
	get_tween().tween_property($Scene/Hammer, "rotation_degrees", 90, hit_time);


# Клиент замахнулся, время удара
func _on_timer_swing_timeout() -> void:
	var timing = randf_range(0.1, 0.5);
	timer_hit.wait_time = timing;
	timer_hit.start();
	update_stage(Stage.HIT);
	if is_can_parry:
		update_coins(coins - coins_loose);
		emit_signal("reward_show", -coins_loose, 0)


# Клиент ударил, время смены клиента
func _on_timer_hit_timeout() -> void:
	timer_shift_client.wait_time = 1;
	timer_shift_client.start();
	update_stage(Stage.SHIFT_CLIENT);


# Вернуть аниматор или сделать его, если он отсутствует (надо доработать)
func get_tween() -> Tween:
	return create_tween();
