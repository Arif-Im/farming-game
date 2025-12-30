extends Machine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play('action')
	$GPUParticles2D.emitting = true
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play('default')
