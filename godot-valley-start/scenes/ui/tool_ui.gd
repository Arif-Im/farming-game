extends Control

@onready var tool_container: HBoxContainer = $ToolContainer
@onready var seed_container: HBoxContainer = $SeedContainer
@onready var hide_timer: Timer = $HideTimer

var tool_texture_scene = preload("res://scenes/ui/tool_ui_texture.tscn")
var current_container: HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for container in [tool_container, seed_container]:
		container.hide()
	texture_setup(Enum.Tool.values(), Data.TOOL_TEXTURES, tool_container)
	texture_setup(Enum.Seed.values(), Data.SEED_TEXTURES, seed_container)
	
func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)
		
func reveal(selection: Enum.Selection):
	var target = 0
	
	hide_timer.start()
	
	for container in [tool_container, seed_container]:
		container.hide()
	
	match selection:
		Enum.Selection.TOOL:
			target = get_parent().current_tool
			current_container = tool_container
		Enum.Selection.SEED:
			target = get_parent().current_seed
			current_container = seed_container
		_:
			print("This selection is not covered!")
			return
		
	current_container.show()
	
	for texture in current_container.get_children():
		texture.highlight(target == texture.tool_enum)

func _on_hide_timer_timeout() -> void:
	current_container.hide()
