extends StaticBody2D

func interact(player: Node2D):
	var weather = 'rain' if Data.forecast_rain else 'sun'
	$AnimatedSprite2D.play(weather)
	$Timer.start()

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("default")
