@tool
extends StaticBody2D

@export_range(0,3,1) var size: int:
	set(value):
		size = value
		random = false
		setup_sprite()
		
@export_enum('Bush', 'Rock') var style: int:
	set(value):
		style = value
		random = false
		setup_sprite()
		
@export var random: bool
		
@export_tool_button('Randomize', "Callable") var randomizer = randomize

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	setup_sprite()
	
func setup_sprite():
	var x = randi_range(0, $Sprite2D.hframes - 1) if random else size
	var y = randi_range(0, $Sprite2D.vframes - 1) if random else style
	$Sprite2D.frame_coords = Vector2i(x, y)
	$CollisionShape2D.disabled = x < 2
	z_index = 1 if x < 2 else 4
	
func randomize():
	size = randi_range(0, $Sprite2D.hframes - 1)
	style = randi_range(0, $Sprite2D.vframes - 1)
	setup_sprite()
