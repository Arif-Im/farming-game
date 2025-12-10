extends Node

func update_tool_animations(direction):
	for state in Data.TOOL_STATE_ANIMATIONS.values():
		update_tool_animation(state, direction)

func update_tool_animation(state: String, value):
	var parameter = "parameters/ToolStateMachine/%s/blend_position" % [state]
	update_animation(parameter, value)

func update_animation(parameter, value):
	$Animation/AnimationTree.set(parameter, value)
