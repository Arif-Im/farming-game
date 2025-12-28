extends Node2D

var in_house: bool:
	set(value):
		in_house = value
		var atlas_coord = opened_door_atlas_coord if in_house else closed_door_atlas_coord
		$WallsLayer.set_cell(door_cells_coord, 0 , atlas_coord)
		
		var tween = create_tween()
		tween.tween_property($RoofLayer.material, "shader_parameter/Progress", 0 if in_house else 1, 0.5)

var door_cells_coord: Vector2i

var closed_door_atlas_coord: Vector2i = Vector2i(0,4)
var opened_door_atlas_coord: Vector2i = Vector2i(1,4)

func _ready() -> void:
	for cell in $WallsLayer.get_used_cells():
		$FloorLayer.set_cell(cell, 0, Vector2.ZERO)
		if $WallsLayer.get_cell_atlas_coords(cell) == Vector2i(0,4):
			door_cells_coord = cell

func _on_house_area_body_entered(body: Node2D) -> void:
	in_house = true

func _on_house_area_body_exited(body: Node2D) -> void:
	in_house = false
