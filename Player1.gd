extends CharacterBody3D

@onready var vista : Node3D = $vista
@onready var camera_3d: Camera3D = $vista/Camera3D

@export var mouse_sensitivity : float = 0.005
@export var SPEED : float = 0.0
@export var SPRINT : float = 10.0
@export var JUMP_VELOCITY : float = 0.0

var rotation_x := 0.0
var sprinting : bool = false
var stamina : float = 100.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotación vertical
		rotation_x -= event.relative.y * mouse_sensitivity

		# Limitar mirada arriba/abajo
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))

		vista.rotation.x = rotation_x

func _ready() -> void:
	SPEED = 6.0
	JUMP_VELOCITY = 6.0

func _physics_process(delta : float) -> void:
	_salto(delta)
	_movimiento(delta)

func _movimiento(delta : float):
	if Input.is_action_pressed("Sprint") and stamina > 0.0:
		sprinting = true
		if stamina <= 0:
			stamina -= stamina * delta
		
	else:
		sprinting = false
		if stamina <= 100:
			stamina += stamina * delta
		
	
	print("Mi estamina es: ", stamina)

	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and sprinting:
		velocity.x = direction.x * SPRINT
		velocity.z = direction.z * SPRINT
	elif direction:
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
