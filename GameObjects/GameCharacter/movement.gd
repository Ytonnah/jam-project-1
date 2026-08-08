extends CharacterBody3D

@export_group("Movement Settings")
@export var speed: float = 5.0

@export var acceleration: float = 10.0
@export var deceleration: float = 12.0
@export var jump_velocity: float = 4.5

@export_group("Look Settings")
@export var mouse_sensitivity: float = 0.003
@export var min_pitch_deg: float = -89.0
@export var max_pitch_deg: float = 89.0

@export var standing_height: float = 1.6
@export var crouching_height: float = 0.2
@export var crouch_speed: float = 10.0

var is_carrying = false



# Node References
@onready var camera_3d: Camera3D = $Neck/Camera3D

func _ready() -> void:
	# Capture and hide the mouse cursor for FPS control
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate character around the Y axis (yaw / left-right)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotate camera around the X axis (pitch / up-down)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		
		# Clamp vertical camera rotation to prevent flipping
		camera_3d.rotation.x = clamp(
			camera_3d.rotation.x,
			deg_to_rad(min_pitch_deg),
			deg_to_rad(max_pitch_deg)
		)

	# Toggle mouse lock with Escape key
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#DEBUG
@onready var interaction_cam = $Neck/Camera3D/DEBUG/InteractionFeedback
func interact_feedback1(text = "bug"):
	interaction_cam.animate_fade_in(text)
func interact_feedback2(text='bug'):
	interaction_cam.animate_fade_in_only(text)
func interact_feedback3()->void:
	interaction_cam.animate_fade_out()
	
func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = jump_velocity
		pass
	#Handle running
	if Input.is_action_pressed("Run") and is_on_floor() and velocity != Vector3.ZERO:
		speed = 8.0
		camera_3d.apply_running_bob(delta,true)
	else:
		camera_3d.apply_running_bob(delta,true)
		
		speed = 5.0
	if Input.is_action_pressed("Crouch"):
		# 1. Determine target height based on input state
		var target_height: float = crouching_height if Input.is_action_pressed("Crouch") else standing_height
		# 2. Smoothly interpolate local Y position toward the target
		camera_3d.position.y = lerp(camera_3d.position.y, target_height, crouch_speed * delta)
		# 3. Update collision shape height
		var shape: CapsuleShape3D = $CollisionShape3D.shape as CapsuleShape3D
		if shape:
			shape.height = lerp(shape.height, target_height, crouch_speed * delta)
			# Keep bottom of collision shape at feet level (origin point)
			#$CollisionShape3D.position.y = $CollisionShape3D.position.y / 2.0
			
			$CollisionShape3D.shape.height  = shape.height / 2.0
			$CollisionShape3D.shape.radius = 2.274
		speed = 3.0
	else:
		var shape: CapsuleShape3D = $CollisionShape3D.shape as CapsuleShape3D
		$CollisionShape3D.shape.height = 6.614
		$CollisionShape3D.shape.radius = 2.274
		speed =  5.0
	
	# Get movement direction based on player rotation
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Smooth movement acceleration & deceleration
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * speed * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * speed * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * speed * delta)

	#camera side movement
	if input_dir.x > 0:
		$Neck.rotation.z = lerp($Neck.rotation.z,deg_to_rad(-5),0.05)
	elif input_dir.x < 0:
		$Neck.rotation.z = lerp($Neck.rotation.z,deg_to_rad(5),0.05)
	else:
		$Neck.rotation.z = lerp($Neck.rotation.z,deg_to_rad(0),0.05)
	move_and_slide()
