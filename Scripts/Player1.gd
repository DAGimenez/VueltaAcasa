extends CharacterBody3D

@onready var vista : Node3D = $vista
@onready var camera_3d: Camera3D = $vista/Camera3D

@export var mouse_sensitivity : float = 0.005
@export var SPEED : float = 3.0
@export var SPRINT : float = 10.0
@export var JUMP_VELOCITY : float = 0.0


var rotation_x := 0.0
var sprinting : bool = false
var stamina : float = 200.0
var MIN_SPRINT := 175.0
var recovery := 100.0
var decrement := 50.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotación vertical
		rotation_x -= event.relative.y * mouse_sensitivity

		# Limitar mirada arriba/abajo
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))

		vista.rotation.x = rotation_x

func _ready() -> void:
	camera_3d.current = is_multiplayer_authority()

	

	if !is_multiplayer_authority():
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta : float) -> void:
	if !is_multiplayer_authority():
		return
	_salto(delta)
	_movimiento(delta)
	actualizar_stamina()

func actualizar_stamina():
	if stamina >= 133.34:
		SPRINT = 8.0
	elif stamina < 66.68:
		SPRINT = 4.0
	else:
		SPRINT = 6.0
		
#	print("mi velocidad es: ", SPRINT, " y mi estamina es de: " , stamina)


func _movimiento(delta : float):
	if Input.is_action_pressed("Sprint") and stamina >= MIN_SPRINT:
		sprinting = true
		
	elif Input.is_action_just_released("Sprint") or stamina <= 0:
		sprinting = false
		
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if sprinting:
			velocity.x = direction.x * SPRINT
			velocity.z = direction.z * SPRINT
			stamina -= recovery * delta
			stamina = clamp(stamina, 0, 200)
		else:
			stamina += decrement * delta
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			stamina = clamp(stamina, 0, 200)
	else:
		stamina += decrement * delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		stamina = clamp(stamina, 0, 200)
	
	move_and_slide()


func _salto(delta : float):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY
