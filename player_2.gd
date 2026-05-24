extends CharacterBody3D

@onready var pivot: Node3D = $Pivot

@export var SPEED = 5.0
@export var SPRINT = 10.0
@export var JUMP_VELOCITY = 4.5
@export var mouse_sensivility := 0.0005

var stamina := 100.0
var sprinting : bool = false
var pitch := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensivility)
		
		pitch -= event.relative.y * mouse_sensivility
		pitch = clamp(pitch, deg_to_rad(90), deg_to_rad(90))
		pivot.rotation.x = pitch

func _salto(delta : float):

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _movimiento(delta : float):
	if Input.is_action_pressed("Sprint") and stamina > 0:
		sprinting = true
		stamina -= stamina * delta
		stamina = clamp(stamina, 0, 100)
	
	else:
		
		sprinting = false
		stamina += stamina * delta
		stamina = clamp(stamina, 0, 100)
	
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


func _physics_process(delta: float) -> void:
	_movimiento(delta)
	_salto(delta)
