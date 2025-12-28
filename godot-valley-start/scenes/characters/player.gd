extends CharacterBody2D

var direction: Vector2 
var last_direction: Vector2 = Vector2(0,1)
var speed:= 50
var current_tool: Enum.Tool = Enum.Tool.AXE
var current_seed: Enum.Seed
var can_move = true
var tool_use_offset: Vector2

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")
@onready var tool_ui: Control = $ToolUI

signal tool_use(tool: Enum.Tool, pos: Vector2)
signal diagnose()
signal day_change()

func _physics_process(_delta: float) -> void:
	if can_move:
		get_basic_input()
		move()
		animate()
		
	if direction:
		last_direction = direction
		var ray_y = direction.y if not direction.x else 0
		$RayCast2D.target_position = Vector2(direction.x,ray_y).normalized() * 20
	
#region Interactions
func get_basic_input():
	handle_tool_selection()
	handle_seed_selection()
	handle_interactions()
	handle_diagnose() 
	
func handle_diagnose():
	if Input.is_action_just_pressed("diagnose"):
		diagnose.emit()

func handle_tool_selection():
	var tool_forward_pressed: bool = Input.is_action_just_pressed("tool_forward")
	var tool_backward_pressed: bool = Input.is_action_just_pressed("tool_backward")
	if tool_forward_pressed or tool_backward_pressed:
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + int(dir), Enum.Tool.size()) as Enum.Tool
		tool_ui.reveal(Enum.Selection.TOOL)
		
func handle_seed_selection():
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = (current_seed + 1) % Enum.Seed.size() as Enum.Seed
		tool_ui.reveal(Enum.Selection.SEED)
		
func handle_interactions():
	if Input.is_action_just_pressed("action"):
		if not $RayCast2D.get_collider():
			tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS.get(current_tool))
			update_animation("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			$RayCast2D.get_collider().interact(self)
#endregion

#region Movements
func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
#endregion

#region Animations
func animate():
	if direction:
		move_state_machine.travel("Walk")
		var direction_animation = Vector2(round(direction.x), round(direction.y))
		update_animation("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		update_animation("parameters/MoveStateMachine/Walk/blend_position", direction_animation)
		update_tool_animations(direction_animation)
	else:
		move_state_machine.travel("Idle")
		
func update_tool_animations(direction):
	for state in Data.TOOL_STATE_ANIMATIONS.values():
		update_tool_animation(state, direction)

func update_tool_animation(state: String, value):
	var parameter = "parameters/ToolStateMachine/%s/blend_position" % [state]
	update_animation(parameter, value)

func update_animation(parameter, value):
	$Animation/AnimationTree.set(parameter, value)
#endregion

func tool_use_emit():
	tool_use_offset = Vector2(0, 4)
	var tool_use_position = position + last_direction * Data.TILE_SIZE + tool_use_offset
	tool_use.emit(current_tool, tool_use_position)
		
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	can_move = true

func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	can_move = false
