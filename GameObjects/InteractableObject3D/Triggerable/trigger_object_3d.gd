extends Area3D

#Note: you can change the colission shape based on what you want it to be.
#1. Add the scene
#2. make it local
#3. Change the colission shape3D child

@export var enabled = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#SIGNAL HANDLERS
signal player_colided

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		emit_signal('player_colided')
		pass


func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
