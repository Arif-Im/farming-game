extends Control

var tool_enum: int

func setup(new_enum_texture: int, main_texture: Texture2D):
	tool_enum = new_enum_texture
	$TextureRect.texture = main_texture

func highlight(selected: bool):
	var tween = create_tween()
	var target_size = Vector2(20, 20) if selected else Vector2(16,16)
	tween.tween_property($TextureRect, "custom_minimum_size", target_size, .1)
