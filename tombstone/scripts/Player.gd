extends KinematicBody

export var speed : float = 20
export var accelaration : float = 15
export var air_accelaration : float = 5
export var gravity : float = 0.98
export var max_terminal_velocity : float = 54
export var jump_power : float = 20

export(float, 0.1, 1) var sensitivity : float = 0.3
export(float, -90, 0) var min_pitch : float = -90
export(float,  0, 90) var max_pitch : float = 90

var velocity : Vector3
var y_velocity : float 

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/CameraBoom/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity
		camera_pivot.rotation_degrees.x -= event.relative.y * sensitivity
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

func _physics_process(delta):
	handle_movement(delta)


func handle_movement(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("moveup"):
		direction -= transform.basis.z
	if Input.is_action_pressed("movedown"):
		direction += transform.basis.z
	if Input.is_action_pressed("moveleft"):
		direction -= transform.basis.x
	if Input.is_action_pressed("moveright"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	
	var accel = accelaration if is_on_floor() else air_accelaration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else :
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_velocity = jump_power
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

