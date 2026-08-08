extends Area3D

#Note: you can change the colission shape based on what you want it to be.
#1. Add to the scene
#2. make it local
#3. Change the colission shape3D child
#4. Linked the nodes with 'Trigger Module Node'
#5. Add Metadata to the linked Object

@export var enabled = true
@export var linked_nodes: Array[Node3D]
var interactable = false


# MAIN
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if interactable:
		if Input.is_action_pressed("Interact"):
			toggle()
			print_debug("interact trigger")
			interactable = false
			await get_tree().create_timer(4).timeout
			interactable = true

func toggle(object:Node3D = null):
	if linked_nodes != null:
		for item in linked_nodes:
			if is_instance_valid(item):
				if item.has_node("TriggerModule"):
					var t = item.get_node('TriggerModule')
					if t.has_method('trigger'):
						t.trigger()
	return

#SIGNAL HANDLERS
signal player_colided

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		interactable = true
		emit_signal('player_colided')
		print_debug("interact trigger")
		#toggle()
		
		pass


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('Player'):
		interactable = false
	pass # Replace with function body.
