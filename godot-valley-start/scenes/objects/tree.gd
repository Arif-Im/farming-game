extends StaticBody2D
@onready var apple_spawn_positions: Node2D = $AppleSpawnPositions
@onready var apples: Node2D = $Apples
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var stump: Sprite2D = $Stump
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var level: Node2D = $"../.."

@export var alive_collider_pos: Vector2 = Vector2(0.0, 5.0)
@export var dead_collider_pos: Vector2 = Vector2(0.0, 8.0)

@export var alive_collider_size: Vector2 = Vector2(8.0, 22.0)
@export var dead_collider_size: Vector2 = Vector2(12,6)

const apple_texture = preload("res://graphics/plants/apple.png")

var occupied_pos: Array[Vector2]

var health := 3:
	set(value):
		health = value
		if health <= 0:
			flash_sprite_2d.hide()
			stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			collision_shape_2d.shape = shape
			collision_shape_2d.position = dead_collider_pos
			

func _ready() -> void:
	$FlashSprite2D.frame = [0,1].pick_random()
	create_apples(3)

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		flash_sprite_2d.flash()
		get_apple()
		health -= 1

func create_apples(num: int):
	var apple_markers = apple_spawn_positions.get_children().duplicate(true)
	apple_markers = apple_markers.filter(func(marker): return marker.position not in occupied_pos)
	for i in num:
		var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture;
		apples.add_child(sprite)
		sprite.position = pos_marker.position
		occupied_pos.append(pos_marker.position)

func get_apple():
	if apples.get_children():
		var apple = apples.get_children().pick_random()
		occupied_pos.erase(apple.position)
		apple.queue_free()
		print("get apple")
		
func handle_day_end():
	if health <= 0:
		var shape = CapsuleShape2D.new()
		shape.radius = alive_collider_pos.x
		shape.height = alive_collider_pos.y
		collision_shape_2d.shape = shape
		collision_shape_2d.position = alive_collider_pos
		stump.hide()
		flash_sprite_2d.show()
	else:
		if apples.get_child_count() < 3:
			create_apples(1)
		else:
			occupied_pos.clear()
	health = 3

func _on_level_day_end() -> void:
	handle_day_end()
