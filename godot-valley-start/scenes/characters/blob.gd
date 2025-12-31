extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('Player')
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var death_state_machine: AnimationNodeStateMachinePlayback = $Animation/AnimationTree.get("parameters/DeathStateMachine/playback")
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D

const STAGGER: float = .25;
const EASE: float = .2;

var speed: int = 1000
var knockback: int = 2000

var direction: Vector2
var direction_animation: Vector2
var last_direction_animation: Vector2 = Vector2.ZERO
var is_dead: bool = false
var is_moving: bool = false
var is_stagger: bool = false
var health := 3:
	set(value):
		health = value
		if health <= 0:
			handle_death_state()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	direction = (player.position - position).normalized()
	set_direction_animation()
	if is_stagger || is_dead:
		velocity *= EASE
	else:
		handle_normal_state(delta)
	move_and_slide()

#region State
func handle_death_state():
	is_dead = true;
	play_death_oneshot()
	await get_tree().create_timer(.75).timeout
	queue_free()

func handle_normal_state(delta: float):
	if position.distance_to(player.position) < 75:
		if is_moving:
			velocity = direction * speed * delta
		else:
			velocity = Vector2.ZERO
		move_state_machine.travel("Move")
	else:
		velocity = Vector2.ZERO
		move_state_machine.travel("Idle")
	update_move_animation()
	update_idle_animation()
	update_death_animation()
#endregion

func hit(tool: Enum.Tool, hit_direction: Vector2):
	if tool == Enum.Tool.SWORD:
		stagger()
		velocity = hit_direction * -1 * knockback
		flash_sprite_2d.flash()
		health -= 1
	
func stagger():
	is_stagger = true
	await get_tree().create_timer(STAGGER).timeout
	is_stagger = false

#region Animation
func play_death_oneshot():
	death_state_machine.travel("Death")
	animation_tree.set("parameters/DeathOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func set_direction_animation():
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
		
func update_idle_animation():
	animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", last_direction_animation)
	
func update_move_animation():
	animation_tree.set("parameters/MoveStateMachine/Move/blend_position", direction_animation)
	
func update_death_animation():
	animation_tree.set("parameters/DeathStateMachine/Death/blend_position", last_direction_animation)
#endregion

func start_move_emit():
	is_moving = true

func end_move_emit():
	is_moving = false
