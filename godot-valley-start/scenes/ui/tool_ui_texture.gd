extends Control

var tool_enum: Enum.Tool

func setup(new_enum_texture: Enum.Tool, main_texture: Texture2D):
	tool_enum = new_enum_texture
	$TextureRect.texture = main_texture
