extends Machine

var is_fishing: bool

func _ready() -> void:
	start_fishing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_fishing:
		$Control/TextureProgressBar.value = 0
		return
	var progress = (1.0 - ($FishProgressTimer.time_left / $FishProgressTimer.wait_time)) * $Control/TextureProgressBar.max_value
	$Control/TextureProgressBar.value = progress

func start_fishing():
	$AnimatedSprite2D.play("left")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("left_idle")
	$FishProgressTimer.start()
	is_fishing = true


func _on_fish_progress_timer_timeout() -> void:
	is_fishing = false
	start_fishing()
