extends Area2D

var velocity: Vector2
var speed: float = 70

func _physics_process(delta: float) -> void:
	position += velocity * delta

func fire(direction: Vector2, parent: Node2D):
	velocity = direction * speed
	parent.add_child(self)
	print("fire")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var hit_direction = (position - body.position).normalized()
		body.hit(Enum.Tool.SWORD, hit_direction)
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
