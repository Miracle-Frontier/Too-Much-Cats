extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -2000.0
var direction = Vector2(0,0)
var GRAVITY = 980
var speed_y_modifier = 2 : set = _on_speed_modifier_set
var jump_height = (JUMP_VELOCITY * JUMP_VELOCITY) / (2 * GRAVITY) * speed_y_modifier

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta * speed_y_modifier
	else:
		velocity.y = JUMP_VELOCITY * speed_y_modifier
		$JumpSound.play()
	direction.x = 0
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("left"): direction.x -= 1
	if direction.x == 0: 
		velocity.x = move_toward(velocity.x, 0, 50) # плавное замедление VELOCITY, чтобы не сразу же
	else:
		velocity.x = direction.x * SPEED
	
	move_and_slide()


func _on_speed_modifier_set(val):
	speed_y_modifier = val
	_calculate_jump_height()
	pass

func _calculate_jump_height():
	jump_height = (JUMP_VELOCITY * JUMP_VELOCITY) / (2 * GRAVITY) * speed_y_modifier
	pass
