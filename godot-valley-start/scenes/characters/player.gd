extends CharacterBody2D

var direction: Vector2 
var speed:= 50
var current_tool: Enum.Tool = Enum.Tool.SWORD
var current_seed: Enum.Seed = Enum.Seed.TOMATO
var can_move = true

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")

func _physics_process(_delta: float) -> void:
	if can_move:
		get_basic_input()
		move()
		animate()
	
func get_basic_input():
	var tool_forward_pressed: bool = Input.is_action_just_pressed("tool_forward")
	var tool_backward_pressed: bool = Input.is_action_just_pressed("tool_backward")
	
	if tool_forward_pressed or tool_backward_pressed:
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + int(dir), Enum.Tool.size()) as Enum.Tool
		
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = (current_seed + 1) % Enum.Seed.size() as Enum.Seed
	
	if Input.is_action_just_pressed("action"):
		print(current_tool)
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS.get(current_tool))
		update_animation("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
func animate():
	if direction:
		move_state_machine.travel("Walk")
		var direction_animation = Vector2(round(direction.x), round(direction.y))
		update_animation("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		update_animation("parameters/MoveStateMachine/Walk/blend_position", direction_animation)
		update_tool_animations(direction_animation)
	else:
		move_state_machine.travel("Idle")
	
	# My implementation
	#match direction:
		#Vector2.DOWN:
			#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.DOWN)
		#Vector2.UP:
			#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.UP)
		#Vector2.RIGHT:
			#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.RIGHT)
		#Vector2.LEFT:
			#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.LEFT)
		#Vector2.ZERO:
			#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.ZERO)

func update_tool_animations(direction):
	for state in Data.TOOL_STATE_ANIMATIONS.values():
		update_tool_animation(state, direction)

func update_tool_animation(state: String, value):
	var parameter = "parameters/ToolStateMachine/%s/blend_position" % [state]
	update_animation(parameter, value)

func update_animation(parameter, value):
	$Animation/AnimationTree.set(parameter, value)

func tool_use_emit():
	print('tool')
		


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	can_move = true


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	can_move = false
