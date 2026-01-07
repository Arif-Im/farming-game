extends Machine

var is_fishing: bool

var adjacent_positions: = {
	Vector2i(0, 0): "down", 
	Vector2i(0, 1): "down", 
	Vector2i(1, 0): "right", 
	Vector2i(0, -1): "up", 
	Vector2i(-1, 0): "left", 
}

var adjacent_position: Vector2i
var anim_name: String

func _ready() -> void:
	pass

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	# Fix this part
	coord = pos / Data.TILE_SIZE
	coord.x += -1 if pos.x < 0 else 0
	coord.y += -1 if pos.y < 0 else 0
	for adjacent_pos in adjacent_positions.keys():
		var possible_water_pos = adjacent_pos + coord
		var in_grass = coord in level.grass.get_used_cells()
		var adjacent_in_water = possible_water_pos in level.water.get_used_cells()
		var adjacent_in_grass = possible_water_pos in level.grass.get_used_cells()
		if adjacent_in_water and not adjacent_in_grass and in_grass:
			adjacent_position = adjacent_pos
			super.setup(pos, level, parent)
			break
	anim_name = adjacent_positions[adjacent_position]
	start_fishing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_fishing:
		$Control/TextureProgressBar.value = 0
		return
	var progress = (1.0 - ($FishProgressTimer.time_left / $FishProgressTimer.wait_time)) * $Control/TextureProgressBar.max_value
	$Control/TextureProgressBar.value = progress

func start_fishing():
	print(anim_name)
	$AnimatedSprite2D.play(anim_name)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play(anim_name + "_idle")
	$FishProgressTimer.start()
	is_fishing = true


func _on_fish_progress_timer_timeout() -> void:
	is_fishing = false
	start_fishing()
