extends Camera3D

var rotation_speed: float = 15.0

func _process(delta: float) -> void:
	var rotation_dir: float = 0.0

	if Input.is_action_pressed("rotate_right"):
		rotation_dir = 1.0
	elif Input.is_action_pressed("rotate_left"):
		rotation_dir = -1.0

	if rotation_dir != 0.0:
		rotate_around_origin(rotation_dir * rotation_speed * delta)

func rotate_around_origin(angle_degrees: float) -> void:
	var angle_radians = deg_to_rad(angle_degrees)
	var rotation_quat = Quaternion(Vector3.UP, angle_radians)
	var rotation_basis = Basis(rotation_quat)
	var new_transform = global_transform

	new_transform.origin -= Vector3.ZERO
	new_transform.basis = rotation_basis * new_transform.basis
	new_transform.origin = rotation_quat * new_transform.origin
	new_transform.origin += Vector3.ZERO

	global_transform = new_transform
