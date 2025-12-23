class_name PlantResource extends Resource

@export var icon_texture: Texture2D
@export var texture: Texture2D
@export var grow_speed: float = 1
@export var max_life = 3
@export var h_frames: int = 3

var age: float
var life: float
var plant_name: String
var dead: bool:
	set(value):
		dead = value
		emit_changed()

func setup(seed: Enum.Seed):
	var statement = "seed: %s" % [seed]
	print(statement)
	
	icon_texture = load(Data.PLANT_DATA[seed]['icon_texture'])
	texture = load(Data.PLANT_DATA[seed]['texture'])
	plant_name = Data.PLANT_DATA[seed]['name']
	grow_speed = Data.PLANT_DATA[seed]['grow_speed']
	h_frames = Data.PLANT_DATA[seed]['h_frames']
	max_life = Data.PLANT_DATA[seed]['death_max']
	life = max_life

func grow(sprite: Sprite2D):
	life = max_life
	age = min(age + grow_speed, sprite.hframes - 1)
	sprite.frame = int(age)

func wither():
	if life > 0:
		life -= 1
		var format = "Life %s" % [life]
		print(format)
		
func is_complete():
	return age >= h_frames
