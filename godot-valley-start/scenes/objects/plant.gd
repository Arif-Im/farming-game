extends StaticBody2D

@export var res: PlantResource

var coord: Vector2i
var sprite: Sprite2D
signal death(coord: Vector2i)

func setup(grid_coord: Vector2i, parent: Node2D, plant_res: PlantResource, plant_death_func: Callable):
	res = plant_res
	position = grid_coord * Data.TILE_SIZE + Vector2i(8,5)
	parent.add_child(self)
	coord = grid_coord
	$FlashSprite2D.texture = res.texture
	death.connect(plant_death_func)

func grow(watered: bool):
	if watered:
		res.grow($FlashSprite2D)
	else:
		res.wither()
		
func is_alive():
	return res.life > 0
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if res.is_complete():
		$FlashSprite2D.flash(.2, .4, queue_free)
		death.emit(coord)
		res.dead = true
