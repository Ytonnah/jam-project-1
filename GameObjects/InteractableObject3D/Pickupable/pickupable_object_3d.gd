extends RigidBody3D

var interactable = false
@export var carry = false
var is_carried = false

# Distance to hold the object in front of the camera
@export var hold_distance: float = 2.5
# Speed multiplier for how quickly the object glides to the target
@export var follow_speed: float = 20.0

signal pickup_obj
signal interact_obj

@onready var player = get_tree().get_first_node_in_group("Player")

func show_interactable_prompt():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("interact_feedback1"):
		player.interact_feedback1("[E] interact")

func pickup():
	queue_free()

func start_carry():
	is_carried = true
	# Disable gravity so the body floats smoothly without dipping
	gravity_scale = 0.0
	# High damping stops the body from swinging/orbiting endlessly
	linear_damp = 10.0
	angular_damp = 10.0
	player.is_carrying = true
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	
	

func stop_carry():
	is_carried = false
	gravity_scale = 1.0
	linear_damp = 0.0
	angular_damp = 0.0
	player.is_carrying = false
	set_collision_layer_value(3,true)
	set_collision_mask_value(3,true)

	

func _process(_delta: float) -> void:
	if interactable and Input.is_action_just_pressed("Interact"):
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.has_method("interact_feedback1"):
			player.interact_feedback1('Picked up ' + str(name))
		
		
		
		if carry:
			pass
		else:
			pickup()

func _physics_process(delta: float) -> void:
	if is_carried:
		carry_object(delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact") and carry and interactable:
		# Get player node reference if not already cached
		if player == null:
			player = get_tree().get_first_node_in_group("Player")
			
		if player == null:
			return
			
		if is_carried and player.is_carrying:
			# DROP: Currently carrying THIS object -> Drop it
			player.is_carrying = false
			stop_carry()
			
			wait_with_tween(3)
			
		elif not player.is_carrying:
			# PICKUP: Not carrying anything -> Pick up THIS object
			player.is_carrying = true
			start_carry()
			
			
		#if is_carried and player.is_carrying:
			#is_carried = false
			#interactable = false
			#player.is_carrying = false
			##carry = false
		#else: 
			#player.is_carrying = true
			#is_carried = true
				#
				
func wait_with_tween(interval: float) -> void:
	set_physics_process(false)
	set_collision_layer_value(3,false)
	create_tween().tween_callback(set_physics_process.bind(true)).set_delay(interval)
	create_tween().tween_callback(set_collision_layer_value.bind(3,true)).set_delay(interval)
				

func carry_object(delta: float) -> void:
	var camera: Camera3D = get_tree().get_first_node_in_group("Player_Camera")
	if camera == null:
		return

	# Target point directly in front of the camera
	var target_pos = camera.global_position - camera.global_transform.basis.z * hold_distance
	
	# Smoothly pull linear velocity toward the target point
	var dir = target_pos - global_position
	linear_velocity = dir * follow_speed

#---- Area Signals
func _on_pickup_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#interactable = true
		#show_interactable_prompt()
		pass

func _on_pickup_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#interactable = false
		pass

#AREA FOR CAMERA
func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player_Camera"):
		interactable = true
		show_interactable_prompt()



func _on_pickup_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player_Camera"):
		interactable = false
		#show_interactable_prompt()
	pass # Replace with function body.
