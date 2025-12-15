extends StaticBody2D
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var apple_spawn_positions: Node2D = $AppleSpawnPositions
@onready var apples: Node2D = $Apples

const apple_texture = preload("res://graphics/plants/apple.png")

func _ready() -> void:
	create_apples(3)

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		flash_sprite_2d.flash()

func create_apples(num: int):
	var apple_markers = apple_spawn_positions.get_children().duplicate(true)
	for i in num:
		var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture;
		apples.add_child(sprite)
		sprite.position = pos_marker.position
