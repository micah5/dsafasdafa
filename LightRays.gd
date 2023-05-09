extends MeshInstance3D

# Reference to the Camera node
var camera: Camera3D

func _ready():
	# Assuming that the camera node is named "Camera", change to match your scene
	camera = get_parent_node_3d().get_node("Camera3D")

func _process(delta):
	#var target_dir = (camera.global_transform.origin - global_transform.origin).normalized()
	#target_dir.y = 0

	# Calculate the angle to the target direction
	#var target_angle = atan2(target_dir.x, target_dir.z)

	# Apply the rotation only to the Y-axis
	#rotation.y = target_angle
