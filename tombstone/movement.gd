extends KinematicBody
export var max_speed = 12
export var gravity = 70
export var jump_impulse = 25

var velocity = Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm : SpringArm = $SpringArm

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_movement(input_vector)
	apply_gravity(delta)
	velocity = move_and_slide(velocity , Vector3.UP)

func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.z = Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")
	input_vector.x = Input.get_action_strength("moveup") - Input.get_action_strength("movedown")
	input_vector = input_vector.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	return input_vector.normalized()
	
func apply_movement(input_vector):
	velocity.x = input_vector.x * max_speed
	velocity.z = input_vector.z * max_speed

func apply_gravity(delta):
	velocity.y -= gravity * delta 
	
var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")

func _process(_delta: float):
	_spring_arm.translation = translation
