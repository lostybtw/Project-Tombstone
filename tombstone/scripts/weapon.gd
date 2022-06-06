extends Node

export var fire_rate = 0.5
export var clip_size = 5
export var reload_rate = 3
 
var current_ammo = clip_size
var can_fire = true
var reloading = false
onready var raycast = $"../RayCast"

func _process(delta):
	if Input.is_mouse_button_pressed(1) and can_fire:
		if current_ammo > 0 and not reloading:
			print("fired weapon")
			can_fire = false
			current_ammo -= 1
			check_collision()
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		elif not reloading:
			print("Reloading")
			reloading = true
			yield(get_tree().create_timer(reload_rate), "timeout")
			current_ammo = clip_size
			reloading = false
			print("Loaded")

func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("rekt" + collider.name)
