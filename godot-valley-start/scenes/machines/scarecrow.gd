extends Machine

var enemies: Array[Node2D]
var closest_enemy: Node2D

@onready var bullet_scene = preload("res://scenes/machines/bullet.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies.append(body)
		if closest_enemy == null:
			closest_enemy = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies.erase(body)


func _on_timer_timeout() -> void:
	if closest_enemy != null and enemies.size() > 0:
		var index = enemies.find_custom(func(enemy): return position.distance_to(enemy.position) <= position.distance_to(closest_enemy.position))
		closest_enemy = enemies[index]
		var direction = (closest_enemy.position - position).normalized()
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		bullet.fire(direction, get_parent())
	
