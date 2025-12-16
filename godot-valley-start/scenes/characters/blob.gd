extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")

var direction_animation: Vector2
var last_direction_animation: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = (player.position - position).normalized()
	
	set_direction_animation(direction)
	
	if position.distance_to(player.position) < 75:
		if is_moving:
			velocity = direction * 1000 * delta
		else:
			velocity = Vector2.ZERO
		handle_move_animation()
	else:
		velocity = Vector2.ZERO
		handle_idle_animation()
		
	move_and_slide()
	
func set_direction_animation(direction: Vector2):
	var x_animation = 0
	var y_animation = 0
	
	if direction.abs().x > direction.abs().y:
		if direction.x < 0:
			x_animation = -1
		else:
			x_animation = 1
	elif direction.abs().x < direction.abs().y:
		if direction.y < 0:
			y_animation = -1
		else:
			y_animation = 1
			
	direction_animation = Vector2(x_animation, y_animation)
	if direction_animation:
		last_direction_animation = direction_animation
		
func handle_idle_animation():
	move_state_machine.travel("Idle")
	$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", last_direction_animation)
	
func handle_move_animation():
	move_state_machine.travel("Move")
	$Animation/AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", direction_animation)

func start_move_emit():
	is_moving = true

func end_move_emit():
	is_moving = false
