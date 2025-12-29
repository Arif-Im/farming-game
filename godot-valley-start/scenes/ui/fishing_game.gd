extends Node2D

var velocity: float
var fish_velocity: float
var progress:= 30.0
var sprite_size: Vector2

var progress_move_speed: float = 50.0
var damping: float = 0.05
var pressed: bool

var bar_velocity: float
var y_range: float = 100
var bar_size: Vector2
var bar_y_range: float
var fish_y_range: float

func _process(delta: float) -> void:
	if visible:
		$FishSprite.position.y += fish_velocity * delta
		$FishSprite.position.y = clamp($FishSprite.position.y, -fish_y_range/2.0, fish_y_range/2.0)
		
		bar_velocity += (-progress_move_speed if pressed else progress_move_speed) * damping
		var min_bar_velocity = 0.0 if $BarSprite.position.y <= -bar_y_range/2.0 else -progress_move_speed
		var max_bar_velocity = 0.0 if $BarSprite.position.y >= bar_y_range/2.0 else progress_move_speed
		bar_velocity = clamp(bar_velocity, min_bar_velocity, max_bar_velocity)
		$BarSprite.position.y += bar_velocity * delta
		$BarSprite.position.y = clamp($BarSprite.position.y, -bar_y_range/2.0, bar_y_range/2.0)
		
		var top_point = $BarSprite.position.y - bar_size.y / 2
		var bottom_point = $BarSprite.position.y + bar_size.y / 2
		
		if $FishSprite.position.y >= top_point and $FishSprite.position.y <= bottom_point:
			progress += 10 * delta
		else:
			progress -= 10 * delta
		$Control/TextureProgressBar.value = progress

func _ready() -> void:
	y_range = $Control/NinePatchRect.get_rect().size.y
	bar_size = $BarSprite.get_rect().size
	bar_y_range = y_range - bar_size.y
	fish_y_range = y_range - $FishSprite.get_rect().size.y

func reveal():
	show()
	$FishSprite.position.y = randf_range(-y_range/2.0, y_range/2.0)
	fish_velocity = randf_range(-20,20)

func hold(is_pressing: bool):
	pressed = is_pressing

func _on_fish_update_timer_timeout() -> void:
	fish_velocity = randf_range(-20,20)
	$FishUpdateTimer.wait_time = randf_range(1,3)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value <= 0 or value >= 100:
		hide()
		get_parent().stop_fishing()
