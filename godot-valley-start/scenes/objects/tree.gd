extends StaticBody2D
@onready var apple_spawn_positions: Node2D = $AppleSpawnPositions
@onready var apples: Node2D = $Apples
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var stump: Sprite2D = $Stump
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const apple_texture = preload("res://graphics/plants/apple.png")
var health := 3:
	set(value):
		health = value
		if health <= 0:
			flash_sprite_2d.hide()
			stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			collision_shape_2d.shape = shape
			collision_shape_2d.position.y = 8
			

func _ready() -> void:
	create_apples(3)

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		flash_sprite_2d.flash()
		get_apple()
		health -= 1

func create_apples(num: int):
	var apple_markers = apple_spawn_positions.get_children().duplicate(true)
	for i in num:
		var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture;
		apples.add_child(sprite)
		sprite.position = pos_marker.position

func get_apple():
	if apples.get_children():
		apples.get_children().pick_random().queue_free()
		print("get apple")
