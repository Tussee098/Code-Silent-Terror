extends CharacterBody3D

@onready var camera = $Camera3D
@onready var animation_player = $playerModel/AnimationPlayer

@export var is_walking = false
@export var is_idle = false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#var mouse_visible = true
var is_haunted = false

var player_id

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Add the gravity.
	if(is_multiplayer_authority()):
		if not is_on_floor():
			velocity.y -= gravity * delta
	
		#Toggle Mouse
		#if Input.is_action_just_pressed("alt_button"):
		#	print("dfsdfs")
		#	mouse_visible = !mouse_visible
		#if mouse_visible:
		#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#else:
		#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		if input_dir != Vector2.ZERO:
			_walk_animation()
		else:
			_idle_animation()
		
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
	move_and_slide()
	



func _walk_animation():
	if !is_walking:
		_stop_walking.rpc()
		pass
	if not animation_player.is_playing():
		_start_walking.rpc()

@rpc("call_local")
func _stop_walking():
	animation_player.stop()

@rpc("call_local")
func _start_walking():
	animation_player.play("Take 001")
	is_walking = true
	is_idle = false


func _idle_animation():
	if is_walking:
		_start_idle.rpc()
	

@rpc("call_local")
func _start_idle():
	animation_player.stop()
	is_walking = false
	is_idle = true


func set_haunted(value : bool):
	is_haunted = value
	set_collision_layer(1000000001)
	print(get_collision_layer_value(1))
	print(get_collision_layer_value(10))
