extends CharacterBody3D

@onready var pivot: Node3D = $Pivot
@onready var camera_3d: Camera3D = $Pivot/SpringArm3D/Camera3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var mouse_sensivility := 0.005


var pitch := 0.0

func _ready() -> void:
	camera_3d.current = is_multiplayer_authority()
	
	if !is_multiplayer_authority():
		return
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
		
	if event is InputEventMouseMotion:
		
		rotate_y(-event.relative.x * mouse_sensivility)
		
		pitch -= event.relative.y * mouse_sensivility
		
		pitch = clamp(pitch, deg_to_rad(-45), deg_to_rad(60))
		
		pivot.rotation.x = pitch

func gravedad(delta : float):

	if not is_on_floor():
		velocity += get_gravity() * delta


		

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


func _physics_process(delta):

	if !is_multiplayer_authority():
		return
	gravedad(delta)
	_movimiento()
