extends Area3D

@export var linked_object:Array[Node3D]

func interact():
	if len(linked_object) != 0:
		for item in linked_object:
			if item.has_method("interact"):
				item.interact()
		pass

func show_interactable_prompt():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("interact_feedback2"):
		player.interact_feedback2("[E] interact")
		
func hide_interactable_prompt():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("interact_feedback3"):
		player.interact_feedback3()


func _on_body_entered(body: Node3D) -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player_Camera"):
		show_interactable_prompt()


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player_Camera"):
		hide_interactable_prompt()
