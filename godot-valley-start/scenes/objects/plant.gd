extends StaticBody2D

@export var res: PlantResource

var coord: Vector2i
var sprite: Sprite2D

func setup(grid_coord: Vector2i, parent: Node2D, plant_res: PlantResource):
	res = plant_res
	position = grid_coord * Data.TILE_SIZE + Vector2i(8,5)
	parent.add_child(self)
	coord = grid_coord
	$Sprite2D.texture = res.texture

func grow(watered: bool):
	if watered:
		res.grow($Sprite2D)
	else:
		res.wither()
		
func is_alive():
	return res.life > 0
