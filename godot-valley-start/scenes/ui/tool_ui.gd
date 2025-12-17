extends Control
@onready var tool_container: HBoxContainer = $ToolContainer
var tool_texture_scene = preload("res://scenes/ui/tool_ui_texture.tscn")

const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES)
	
func texture_setup(enum_list: Array, textures: Dictionary):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		tool_container.add_child(tool_texture)
