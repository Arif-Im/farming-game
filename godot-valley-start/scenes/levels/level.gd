extends Node2D
@onready var soil: TileMapLayer = $"Tilemap Layers/Soil"
@onready var water_patches: TileMapLayer = $"Tilemap Layers/Water Patches"
@onready var grass: TileMapLayer = $"Tilemap Layers/Grass"
@onready var water: TileMapLayer = $"Tilemap Layers/Water"
@onready var plant_scene = preload("res://scenes/objects/plant.tscn")
@onready var objects: Node2D = $Objects
@onready var player: CharacterBody2D = $Objects/Player
@onready var debug: TileMapLayer = $"Tilemap Layers/Debug"

var used_cells: Array[Vector2i]
var has_soil: bool = false
var grid_coord: Vector2i

func _physics_process(_delta: float) -> void:
	pass
	
#region Debugging
func debug_tile():
	var player_position = player.position + player.last_direction * Data.TILE_SIZE + Vector2(0,4)
	var x = int(player_position.x / Data.TILE_SIZE)
	var y = int(player_position.y / Data.TILE_SIZE)
	var grid_coord: Vector2i = Vector2i(x, y)
	grid_coord.x += -1 if x < 0 else 0
	grid_coord.y += -1 if y < 0 else 0
	debug.clear()
	debug.set_cell(grid_coord, 1, Vector2i(1,3))
#endregion

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	set_grid_coord(pos)
	has_soil = grid_coord in soil.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			handle_hoe()
		Enum.Tool.WATER:
			handle_water()
		Enum.Tool.FISH:
			handle_fish()
		Enum.Tool.SEED:
			handle_water()
		Enum.Tool.AXE, Enum.Tool.SWORD:
			handle_damaging_tools(pos, tool)
			
func handle_damaging_tools(pos: Vector2, tool: Enum.Tool):
	for object in get_tree().get_nodes_in_group('Objects'):
		if object.position.distance_to(pos) < 20:
			object.hit(tool)

func set_grid_coord(pos: Vector2):
	var x = int(pos.x / Data.TILE_SIZE)
	var y = int(pos.y / Data.TILE_SIZE)
	grid_coord = Vector2i(x, y)
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0

#region Actions
func handle_seed():
	if has_soil and grid_coord not in used_cells:
		var plant = plant_scene.instantiate()
		plant.setup(grid_coord, objects)
		used_cells.append(grid_coord)
	
func handle_fish():
	var water_cell = water.get_cell_tile_data(grid_coord) as TileData
	var in_grass = grid_coord in grass.get_used_cells()
	var fishable = water_cell and !in_grass
	var statement = "In grass is %s\n" % [in_grass]
	statement = statement + "Has water cell is %s\n" % [water_cell != null]
	statement = statement + "Fishable is %s\n" % [fishable]
	statement = statement + "Grid coord is %s" % [grid_coord]
	print(statement)
	
func handle_hoe():
	var cell = grass.get_cell_tile_data(grid_coord)
	if cell and cell.get_custom_data('farmable'):
		soil.set_cells_terrain_connect([grid_coord], 0, 0)
	print(grid_coord)
	
func handle_water():
	var statement = "Is on soil: %s" % has_soil
	print(statement)
	
	if(has_soil):
		var random = randi_range(0, 2)
		water_patches.set_cell(grid_coord, 0, Vector2(random, 0))
#endregion
