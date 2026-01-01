extends Machine

var lvl: Node2D

var sprinkle_positions: Array[Vector2i] = [
	Vector2i(0, 1), 
	Vector2i(1, 1), 
	Vector2i(1, 0), 
	Vector2i(1, -1), 
	Vector2i(0, -1), 
	Vector2i(-1, -1), 
	Vector2i(-1, 0), 
	Vector2i(-1, 1), 
]

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	super.setup(pos, level, parent)
	lvl = level

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play('action')
	$GPUParticles2D.emitting = true
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play('default')
	
	for pos in sprinkle_positions:
		var sprinkle_position = pos + coord
		print(sprinkle_position)
		if sprinkle_position in lvl.soil.get_used_cells():
			var random = randi_range(0, 2)
			lvl.water_patches.set_cell(sprinkle_position, 0, Vector2(random, 0))
