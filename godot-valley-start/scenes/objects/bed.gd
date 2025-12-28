extends StaticBody2D

func interact(player: Node2D):
	player.day_change.emit()
