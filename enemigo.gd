extends CharacterBody3D


@export var SPEED = 5.0
@onready var navAgent =$NavigationAgent3D
@onready var target =$"../Player1"
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var current_location = global_transform.origin
	var nextLocation = navAgent.get_next_path_position()
	var nextVelocity=(nextLocation - current_location).normalized() *SPEED
	
	velocity= velocity.move_toward(nextVelocity,0.2)
	_target_position(target)
	move_and_slide()
	
func _target_position(target):
	navAgent.target_position = target.global_transform.origin
