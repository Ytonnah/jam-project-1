extends RigidBody3D

var interactable = false



signal pickup_obj
func pickup():
	queue_free()


signal interact_obj
func interact():
	pass
	
func contactTrigger():
	pass
	

#---- Callback Actions
func text_feedback(text):
	pass
func sound_feedback():
	pass
func interact_callback():
	pass

#-----------------------------------------------
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interactable  and Input.is_action_just_pressed("Interact"):
		pickup()
	pass


func _on_pickup_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print_debug('player entered')
		interactable = true



func _on_pickup_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		interactable = false
