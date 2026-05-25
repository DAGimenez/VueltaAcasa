extends CharacterBody3D

@onready var pivot: Node3D = $Pivot

@export var SPEED = 5.0
@export var SPRINT = 8.0
@export var JUMP_VELOCITY = 4.5
@export var mouse_sensivility := 0.005

var stamina := 200.0
var sprinting : bool = false
var pitch := 0.0
var Min_Sprinting := 175.0
var recovery := 100.0
var decrement := 50.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensivility)
		
		pitch -= event.relative.y * mouse_sensivility
		
		pitch = clamp(pitch, deg_to_rad(-45), deg_to_rad(60))
		
		pivot.rotation.x = pitch

func _salto(delta : float):

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func actualizar_stamina():
	if stamina >= 133.34:
		SPRINT = 8.0
	elif stamina < 66.68:
		SPRINT = 4.0
	else:
		SPRINT = 6.0
		
	print("mi velocidad es: ", SPRINT, " y mi estamina es de: " , stamina)
		

func _movimiento(delta : float):
	if Input.is_action_pressed("Sprint") and stamina >= Min_Sprinting:
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


func _physics_process(delta: float) -> void:
	_movimiento(delta)
	_salto(delta)
	actualizar_stamina()
