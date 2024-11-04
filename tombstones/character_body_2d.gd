extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
var direction = 0

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY


	if not Input.is_action_pressed("click"): 
		direction = 0
		velocity.x = sign(velocity.x)*max(abs(velocity.x)-1,0)
	else:
		velocity.x = direction * SPEED
	
	
	
	move_and_slide()


func left(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	direction = -1
func right(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	direction = 1
