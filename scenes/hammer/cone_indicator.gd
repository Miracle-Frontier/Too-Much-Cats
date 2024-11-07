extends Node2D

signal clear_cones
signal add_cone

var circle_radius: float = 850.0  # Радиус круга
var cones: Array = []  # Массив для хранения данных о конусах
var checked_cones: Array = []  # Уже пройденые конусы

func _ready():
	queue_redraw()

func _draw():
	# Рисуем каждый конус
	for cone in cones:
		draw_cone(cone, Color(1, 0, 0))
	for cone in checked_cones:
		draw_cone(cone, Color(0, 1, 0))

func draw_cone(cone, color):
	var cone_angle = cone.angle
	var cone_direction = cone.direction
	var direction_rad = deg_to_rad(cone_direction)
	var half_angle_rad = deg_to_rad(cone_angle / 2)
	var point1 = Vector2(cos(direction_rad - half_angle_rad), sin(direction_rad - half_angle_rad)) * circle_radius
	var point2 = Vector2(cos(direction_rad + half_angle_rad), sin(direction_rad + half_angle_rad)) * circle_radius

	# Рисуем закругленный конус
	var points = [Vector2.ZERO, point1, point2]
	draw_colored_polygon(points, color) # Красный цвет конуса

func _process(delta):
	queue_redraw()

# Обработчик сигнала для очистки конусов
func _on_clear_cones():
	cones.clear()
	checked_cones.clear()
	queue_redraw()

# Обработчик сигнала для добавления нового конуса
func _on_add_cone(angle: float, direction: float):
	cones.append({ "angle": angle, "direction": direction - 180 })
	queue_redraw()
	
# Обработчик сигнала для добавления нового конуса
func _on_add_checked_cone(angle: float, direction: float):
	checked_cones.append({ "angle": angle, "direction": direction - 180 })
	queue_redraw()
