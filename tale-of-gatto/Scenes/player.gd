extends CharacterBody2D


const SPEED = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var terrain_manager = $"../Terrain Manager"
@onready var player: CharacterBody2D = $"."

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	
	handle_movement(x_direction, y_direction)
	handle_animation(x_direction, y_direction)
	
	if(Input.is_action_just_pressed("interact")):
		terrain_manager._interact(player.position)

func handle_movement(x_direction, y_direction):
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func handle_animation(x_direction, y_direction):
	if x_direction == 0 && y_direction == 0:
		if animated_sprite.animation == "Walk Up":
			animated_sprite.play("Idle Up")
		elif animated_sprite.animation == "Walk Down":
			animated_sprite.play("Idle Down")
		elif animated_sprite.animation == "Walk Left":
			animated_sprite.play("Idle Left")
		elif animated_sprite.animation == "Walk Right":
			animated_sprite.play("Idle Right")
		elif animated_sprite.animation == "Walk Down Left":
			animated_sprite.play("Idle Down Left")
		elif animated_sprite.animation == "Walk Down Right":
			animated_sprite.play("Idle Down Right")
		elif animated_sprite.animation == "Walk Up Left":
			animated_sprite.play("Idle Up Left")
		elif animated_sprite.animation == "Walk Down Right":
			animated_sprite.play("Idle Up Right")
	elif x_direction != 0 && y_direction != 0:
		if x_direction < 0 && y_direction > 0:
			animated_sprite.play("Walk Down Left")
		if x_direction > 0 && y_direction > 0:
			animated_sprite.play("Walk Down Right")
		if x_direction < 0 && y_direction < 0:
			animated_sprite.play("Walk Up Left")
		if x_direction > 0 && y_direction < 0:
			animated_sprite.play("Walk Up Right")
	else:
		if x_direction < 0:
			animated_sprite.play("Walk Left")
		if x_direction > 0:
			animated_sprite.play("Walk Right")
		if y_direction < 0:
			animated_sprite.play("Walk Up")
		if y_direction > 0:
			animated_sprite.play("Walk Down")
		

	move_and_slide()
