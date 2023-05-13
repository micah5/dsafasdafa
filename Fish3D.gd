extends CharacterBody3D

const SPEED = 1.0
const TURN_SPEED = 2.0

var direction = Vector3.FORWARD
var raycast

func _ready():
	raycast = $RayCast3D

func _physics_process(delta):
	var new_direction = direction

	# Check for obstacles. If there is one, change direction to avoid it.
	if raycast.is_colliding():
		new_direction = -raycast.get_collision_normal()

	# Gradually turn towards the new direction
	direction = direction.lerp(new_direction, TURN_SPEED * delta)

	# Normalize the direction and scale it by the speed to get the velocity.
	velocity = direction.normalized() * SPEED

	# Move the fish
	move_and_slide()
