extends RichTextLabel

# Duration of the fade in seconds

@export var fade_duration: float = 0.5
@export var display_delay: float = 2.0

# Store the active tween so it can be interrupted/reset
var active_tween: Tween

func _ready() -> void:
	modulate.a = 0.0


func animate_fade_in_only(new_text: String = "") -> void:
	if new_text != "":
		text = new_text

	# Kill the previous tween if it's currently running or delayed
	if active_tween and active_tween.is_valid():
		active_tween.kill()

	# Create a new active tween sequence
	active_tween = get_tree().create_tween()

	# 1. Fade in
	active_tween.tween_property(self, "modulate:a", 1.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	
	
## Fades text in, holds for display_delay seconds, then fades out.
## If called again while running/waiting, it safely cancels and restarts.
func animate_fade_in(new_text: String = "") -> void:
	if new_text != "":
		text = new_text

	# Kill the previous tween if it's currently running or delayed
	if active_tween and active_tween.is_valid():
		active_tween.kill()

	# Create a new active tween sequence
	active_tween = get_tree().create_tween()

	# 1. Fade in
	active_tween.tween_property(self, "modulate:a", 1.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# 2. Delay / Hold step
	active_tween.tween_interval(display_delay)
	
	# 3. Fade out
	active_tween.tween_property(self, "modulate:a", 0.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
		

## Fades the label out from its current opacity to 0%
func animate_fade_out() -> void:
	var t = get_tree().create_tween()
	# Transition modulate:a to 0.0 over fade_duration seconds
	t.tween_property(self, "modulate:a", 0.0, fade_duration)\
	 .set_trans(Tween.TRANS_SINE)\
	 .set_ease(Tween.EASE_IN_OUT)

## Sequence: Fades out, updates text, then fades back in
func fade_to_text(new_text: String) -> void:
	var t = get_tree().create_tween()
	
	# Fade out
	t.tween_property(self, "modulate:a", 0.0, fade_duration)
	# Update text once fully transparent
	t.tween_callback(func(): text = new_text)
	# Fade back in
	t.tween_property(self, "modulate:a", 1.0, fade_duration)
