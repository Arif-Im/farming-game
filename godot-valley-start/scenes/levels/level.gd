extends Node2D
@onready var soil: TileMapLayer = $"Tilemap Layers/Soil"
@onready var water_patches: TileMapLayer = $"Tilemap Layers/Water Patches"
@onready var grass: TileMapLayer = $"Tilemap Layers/Grass"
@onready var water: TileMapLayer = $"Tilemap Layers/Water"
@onready var plant_scene = preload("res://scenes/objects/plant.tscn")
@onready var objects: Node2D = $Objects

var used_cells: Array[Vector2i]

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var x = int(pos.x / Data.TILE_SIZE)
	var y = int(pos.y / Data.TILE_SIZE)
	var grid_coord: Vector2i = Vector2i(x, y)
	var has_soil = grid_coord in soil.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			handle_hoe(grid_coord)
		Enum.Tool.WATER:
			handle_water(grid_coord, has_soil)
		Enum.Tool.FISH:
			handle_fish(grid_coord)
		Enum.Tool.SEED:
			handle_water(grid_coord, has_soil)
			
func handle_seed(grid_coord: Vector2i, has_soil: bool):
	if has_soil and grid_coord not in used_cells:
		var plant = plant_scene.instantiate()
		plant.setup(grid_coord, objects)
		used_cells.append(grid_coord)
	
func handle_fish(grid_coord: Vector2i):
	var water_cell = water.get_cell_tile_data(grid_coord) as TileData
	var in_grass = grid_coord in grass.get_used_cells()
	var fishable = water_cell and !in_grass
	var statement = "In grass: %s, Has water cell: %s, Fishable is %s" % [in_grass, water_cell != null, fishable]
	print(statement)
			
func handle_hoe(grid_coord: Vector2i):
	var cell = grass.get_cell_tile_data(grid_coord)
	if cell and cell.get_custom_data('farmable'):
		soil.set_cells_terrain_connect([grid_coord], 0, 0)
	print(grid_coord)
	
func handle_water(grid_coord: Vector2, has_soil: bool):
	var statement = "Is on soil: %s" % has_soil
	print(statement)
	
	if(has_soil):
		var random = randi_range(0, 2)
		water_patches.set_cell(grid_coord, 0, Vector2(random, 0))
