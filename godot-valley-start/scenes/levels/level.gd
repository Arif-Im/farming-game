extends Node2D
@onready var soil: TileMapLayer = $"Layers/Soil"
@onready var water_patches: TileMapLayer = $"Layers/Water Patches"
@onready var grass: TileMapLayer = $"Layers/Grass"
@onready var water: TileMapLayer = $"Layers/Water"
@onready var debug: TileMapLayer = $"Layers/Debug"
@onready var plant_scene = preload("res://scenes/objects/plant.tscn")
@onready var objects: Node2D = $Objects
@onready var player: CharacterBody2D = $Objects/Player
@onready var day_timer: Timer = $Timers/DayTimer
@onready var day_time_color: CanvasModulate = $Overlay/DayTimeColor
@onready var day_transition_layer: ColorRect = $Overlay/CanvasLayer/DayTransitionLayer
@onready var plant_info_container: Control = $Overlay/CanvasLayer/PlantInfoContainer

@export var daytime_color: Gradient
@export var rain_tint: Color
var is_raining: bool:
	set(value):
		is_raining = value
		$Layers/Splash.emitting = is_raining
		$Layers/Raindrops.emitting = is_raining

var used_cells: Array[Vector2i]
var has_soil: bool = false
var grid_coord: Vector2i

signal day_end()

func _ready() -> void:
	Data.forecast_rain = randf_range(0, 1) >= 0.75
	is_raining = Data.forecast_rain
	if is_raining: 
		enable_all_water_patches()

func _process(_delta: float) -> void:
	var daytime_point = 1 - (day_timer.time_left / day_timer.wait_time)
	var color = daytime_color.sample(daytime_point) * get_weather_tint()
	day_time_color.color = color
	if Input.is_action_just_pressed("day_change"):
		day_restart()
		
func get_weather_tint() -> Color:
	return rain_tint if is_raining else Color(1,1,1)

func day_restart():
	var tween = create_tween()
	tween.tween_property(day_transition_layer.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(day_transition_layer.material, "shader_parameter/progress", 0.0, 1.0)

func level_reset():
	day_end.emit()
	day_timer.start()

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
			handle_seed()
		Enum.Tool.AXE, Enum.Tool.SWORD:
			handle_damaging_tools(pos, tool)

func _on_player_diagnose() -> void:
	plant_info_container.visible = not plant_info_container.visible

func set_grid_coord(pos: Vector2):
	var x = int(pos.x / Data.TILE_SIZE)
	var y = int(pos.y / Data.TILE_SIZE)
	grid_coord = Vector2i(x, y)
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0

#region Actions
func handle_damaging_tools(pos: Vector2, tool: Enum.Tool):
	for object in get_tree().get_nodes_in_group('Objects'):
		if object.position.distance_to(pos) < 20:
			object.hit(tool)
			
func handle_seed():
	if has_soil and grid_coord not in used_cells:
		var plant_res = PlantResource.new()
		plant_res.setup(player.current_seed)
		var plant = plant_scene.instantiate()
		plant.setup(grid_coord, objects, plant_res, plant_death)
		plant_info_container.add(plant_res)
		used_cells.append(grid_coord)
		print("Used cells: %s" % [used_cells])
	
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
		var random = randi_range(0, 2)
		water_patches.set_cell(grid_coord, 0, Vector2(random, 0))
	print(grid_coord)
	
func handle_water():
	var statement = "Is on soil: %s" % has_soil
	print(statement)
	
	if(has_soil):
		var random = randi_range(0, 2)
		water_patches.set_cell(grid_coord, 0, Vector2(random, 0))
#endregion

func _on_day_end() -> void:
	for plant in get_tree().get_nodes_in_group('Plants'):
		update_plant(plant)
	water_patches.clear()
	is_raining = Data.forecast_rain
	if is_raining: 
		enable_all_water_patches()
	Data.forecast_rain = randf_range(0, 1) >= 0.75
	print("Tomorrow will rain: %s" % Data.forecast_rain)
	
func enable_all_water_patches():
	for cell in soil.get_used_cells():
		var random = randi_range(0, 2)
		water_patches.set_cell(cell, 0, Vector2(random, 0))
	
func update_plant(plant: StaticBody2D):
	var in_water_patches = plant.coord in water_patches.get_used_cells()
	plant.grow(in_water_patches)
	plant_info_container.update()
	
func plant_death(coord: Vector2i):
	used_cells.erase(coord)
	print("Used cells: %s" % [used_cells])
