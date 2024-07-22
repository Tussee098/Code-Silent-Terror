extends CharacterBody3D

@onready var camera = $Camera3D
@onready var animation_player = $playerModel/AnimationPlayer


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event):

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		


func _physics_process(delta):

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	$playerModel.rotation.y = -PI
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$playerModel.rotation.y = -input_dir.angle() + (PI/2)
		# Play walking animation
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		# Play idle animation
	# Counteract root motion by resetting the model's position
	print(move_and_slide())
	



