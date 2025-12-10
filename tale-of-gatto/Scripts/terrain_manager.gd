extends Node2D
@onready var node_2d: Node2D = $"."
@onready var interactable_terrain: TileMapLayer = $"Interactable Terrain"
const CROP = preload("uid://byxjkvh3snmnh")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _interact(interact_position) -> void:
	var clicked_tile = interactable_terrain.local_to_map(interact_position)
	var tile_data = interactable_terrain.get_cell_tile_data(clicked_tile)
	
	if(tile_data != null):
		var crop = CROP.instantiate()
		crop.position = interactable_terrain.map_to_local(clicked_tile)
		add_child(crop)
		print("Tile is present")
