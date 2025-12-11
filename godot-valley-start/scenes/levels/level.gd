extends Node2D
@onready var soil: TileMapLayer = $"Tilemap Layers/Soil"
@onready var water_patches: TileMapLayer = $"Tilemap Layers/Water Patches"
@onready var grass: TileMapLayer = $"Tilemap Layers/Grass"
@onready var water: TileMapLayer = $"Tilemap Layers/Water"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var x = int(pos.x / Data.TILE_SIZE)
	var y = int(pos.y / Data.TILE_SIZE)
	var grid_coord: Vector2i = Vector2i(x, y)
	match tool:
		Enum.Tool.HOE:
			handle_hoe(grid_coord)
		Enum.Tool.WATER:
			handle_water(grid_coord)
		Enum.Tool.FISH:
			handle_fish(grid_coord)
	
func handle_fish(grid_coord: Vector2i):
	var water_cell = water.get_cell_tile_data(grid_coord) as TileData
	var in_grass = grid_coord in grass.get_used_cells()
	var fishable = water_cell and !in_grass
	var statement = "Fishable is %s" % fishable
	print(statement)
			
func handle_hoe(grid_coord: Vector2i):
	var cell = grass.get_cell_tile_data(grid_coord)
	if cell and cell.get_custom_data('farmable'):
		soil.set_cells_terrain_connect([grid_coord], 0, 0)
	print(grid_coord)
	
func handle_water(grid_coord: Vector2):
	var cell_data = soil.get_cell_tile_data(grid_coord) as TileData
	var is_on_soil = cell_data != null
	var statement = "Is on soil: %s" % is_on_soil
	print(statement)
	
	if(is_on_soil):
		var random = randi_range(0, 2)
		water_patches.set_cell(grid_coord, 0, Vector2(random, 0))
