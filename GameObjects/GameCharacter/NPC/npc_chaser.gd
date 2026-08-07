extends CharacterBody3D

@export_group("Movement Settings")
@export var speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 12.0
@export var stopping_distance: float = 1.5 # Distance to stop before hitting player

@export_group("Target Settings")
@export var target_group: StringName = &"Player"
@export var rotation_speed: float = 10.0 # Speed at which the NPC turns toward player

var target_node: Node3D = null

func _ready() -> void:
	_find_target()

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Locate target if missing or queued for deletion
	if not is_instance_valid(target_node):
		_find_target()

	var direction := Vector3.ZERO

	if is_instance_valid(target_node):
		var target_pos := target_node.global_position
		var current_pos := global_position
		
		# Distance ignoring Y axis height difference
		var distance_to_target := Vector2(current_pos.x, current_pos.z).distance_to(Vector2(target_pos.x, target_pos.z))

		if distance_to_target > stopping_distance:
			# Calculate direction vector on X/Z plane
			direction = Vector3(target_pos.x - current_pos.x, 0, target_pos.y - current_pos.y) # XZ plane
			direction = Vector3(target_pos.x - current_pos.x, 0, target_pos.z - current_pos.z).normalized()

			# Smoothly rotate NPC face toward target direction
			var target_rotation_y := atan2(-direction.x, -direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation_y, rotation_speed * delta)

	# Smooth movement acceleration & deceleration
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * speed * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * speed * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * speed * delta)

	move_and_slide()

# Find first node in designated group
func _find_target() -> void:
	var players := get_tree().get_nodes_in_group(target_group)
	if players.size() > 0:
		target_node = players[0] as Node3D

func caught():
	var player:CharacterBody3D = get_tree().get_first_node_in_group(target_group)
	#player.rotate()
	
