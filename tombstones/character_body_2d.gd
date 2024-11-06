extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -2000.0
var direction = Vector2(0,0)
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = JUMP_VELOCITY
	direction.x = 0
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("left"): direction.x -= 1
	if direction.x == 0: 
		velocity.x = move_toward(velocity.x, 0, 50) # плавное замедление VELOCITY, чтобы не сразу же
	else:
		velocity.x = direction.x * SPEED
	
	move_and_slide()
