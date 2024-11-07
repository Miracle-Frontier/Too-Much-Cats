extends Node2D

signal coins_updated(new_value);
signal stage_updated(new_stage);
signal last_hit_rotate_update(new_rotate);
signal reward_show(count, precent);

### Данные миниигры
var coins: int = 0  # Текущее количество монет
var coins_perfect_reward: int = 30  # Награда за хороший удар
var coins_loose: int = 20  # Потеря при промахе
var current_stage: Stage = Stage.SHIFT_CLIENT;  # Текущая стадия игры
var tween: Tween = null  # Аниматор удара
var last_rotation = 0  # Информация о последнем зафиксированном градусе парирования
var target_cones: Array = []  # Конусы, по которым должен проводиться удар [угол, наклон]

### Настройка сложности
@export var difficult: float = 0.2  # От 0.0 до 1.0
@export var dif_max_cones: int = 4  # Количество конусов при сложности 1.0 (min: 0)
@export var dif_min_time = [1.9, 1.7]  # Диапазон времени замаха при мин. сложности
@export var dif_max_time = [1.7, 1.3]  # Диапазон времени замаха при макс. сложности
@export var dif_max_coin_multiplier: float = 1.3  # Максимальный множитель награды за успешный удар (min: 0)
@export var dif_min_cone_angle: float = 40  # Угол конуса при мин. сложности
@export var dif_max_cone_angle: float = 15  # Угол конуса при макс. сложности
@export var dif_cone_angle_spread: float = 2.5  # Насколько сильно может отклониться угол конуса 

### Компоненты
@onready var timer_shift_client = $TimerShiftClient;  # Время смены клиента
@onready var timer_swing = $TimerSwing;  # Время замаха молотком
@onready var timer_hit = $TimerHit;  # Время удара
@onready var hammer = $Scene/Hammer  # Молот
@onready var cone_indicators = $Scene/Indicators  # Индикаторы удара


# Все стадии игры
enum Stage {
	SHIFT_CLIENT = 0,  # Смена клиента
	SWING = 1,  # Замах
	HIT = 2,  # Удар
}


func _ready() -> void:
	generate_cones()
	timer_shift_client.wait_time = 2.0;
	timer_shift_client.start();


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if current_stage == Stage.SWING:
			# Анимация переключателя
			$Scene/Controller/ClickerOff.visible = false;
			$Scene/Controller/ClickerOn.visible = true;
			$Scene/Coffin/VentOff.visible = false;
			$Scene/Coffin/VentOn.visible = true;
			
			# Расчет попадания
			var reward = null
			var multiplier: float = get_dif_value(1, dif_max_coin_multiplier)
			var current_rotate = hammer.rotation_degrees + 90
			var precent = 1
			var checked_cone = null
			for cone in target_cones:
				if abs(current_rotate - cone.direction) <= cone.angle / 2:
					reward = coins_perfect_reward * multiplier
					checked_cone = cone
					cone_indicators._on_add_checked_cone(cone.angle, cone.direction)
					break
			target_cones.erase(checked_cone)
			if reward == null:
				reward = -coins_loose
			update_coins(coins + reward);
			update_last_hit_rotate(precent);
			emit_signal("reward_show", reward, precent);

	if Input.is_action_just_released("click"):
		# Анмиация переключателя
		$Scene/Controller/ClickerOff.visible = true;
		$Scene/Controller/ClickerOn.visible = false;
		$Scene/Coffin/VentOff.visible = true;
		$Scene/Coffin/VentOn.visible = false;


func generate_cones():
	cone_indicators._on_clear_cones()
	target_cones.clear()
	var used_angles: Array = []
	var cone_count: int = int(get_dif_value(1, dif_max_cones))
	while target_cones.size() < cone_count:
		var random_direction = randi() % 180
		var overlap = false
		var cone_angle: float = get_dif_value(dif_min_cone_angle, dif_max_cone_angle)
		cone_angle += randf_range(-dif_cone_angle_spread, dif_cone_angle_spread)
		for angle in used_angles:
			if abs(angle - random_direction) < cone_angle:
				overlap = true
				break
		if not overlap:
			var cone = { "angle": cone_angle, "direction": random_direction }
			target_cones.append(cone)
			used_angles.append(random_direction)
			cone_indicators._on_add_cone(cone_angle, random_direction)


func get_dif_value(min, max):
	return min + (max - min) * difficult


# Обновление количества денег, передача сигнала
func update_coins(new_value: int) -> void:
	coins = new_value
	emit_signal("coins_updated", coins)


# Обновление стадии игры, передача сигнала
func update_stage(new_stage: Stage) -> void:
	current_stage = new_stage
	emit_signal("stage_updated", current_stage)


# Обновление информации о последнем угле
func update_last_hit_rotate(new_rotate) -> void:
	last_rotation = new_rotate
	emit_signal("last_hit_rotate_update", new_rotate)


# Клиент был сменен, время замаха
func _on_timer_shift_client_timeout() -> void:
	var start_time: float = get_dif_value(dif_min_time[0], dif_max_time[0])
	var end_time: float = get_dif_value(dif_min_time[1], dif_max_time[1])
	var hit_time = randf_range(start_time, end_time)
	timer_swing.wait_time = hit_time
	timer_swing.start()
	update_stage(Stage.SWING)
	hammer.rotation_degrees = -90
	get_tween().tween_property($Scene/Hammer, "rotation_degrees", 90, hit_time)


# Клиент замахнулся, время удара
func _on_timer_swing_timeout() -> void:
	var timing = randf_range(0.1, 0.5)
	timer_hit.wait_time = timing
	timer_hit.start()
	update_stage(Stage.HIT)
	if target_cones:
		update_coins(coins - coins_loose)
		emit_signal("reward_show", -coins_loose, 0);


# Клиент ударил, время смены клиента
func _on_timer_hit_timeout() -> void:
	generate_cones()
	timer_shift_client.wait_time = 1
	timer_shift_client.start()
	update_stage(Stage.SHIFT_CLIENT)


# Вернуть аниматор или сделать его, если он отсутствует (надо доработать)
func get_tween() -> Tween:
	return create_tween();
