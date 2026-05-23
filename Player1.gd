extends CharacterBody3D


@export var SPEED := 0.0
@export var JUMP_VELOCITY := 0.0

func _ready() -> void:
	SPEED = 8.0
	JUMP_VELOCITY = 6.0

func _physics_process(delta: float) -> void:
	_salto(delta)
	_movimiento()

func _movimiento():

	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _salto(delta : float):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY
