extends Camera3D

@export var run_bob_speed : float = 12.0
@export var run_bob_amount : float = 0.12

var timer : float = 0.0
@onready var default_y : float = transform.origin.y
@onready var default_x : float = transform.origin.x

func apply_running_bob(delta: float, is_running: bool):
	if is_running:
		timer += delta * run_bob_speed
		transform.origin.y = default_y + sin(timer) * run_bob_amount
		#transform.origin.x = default_x + sin(timer) * run_bob_amount 
	else:
		timer = 0.0
		transform.origin.y = lerp(transform.origin.y, default_y, delta * 10.0)
		#transform.origin.x = lerp(transform.origin.x, default_x, delta * 10.0)
