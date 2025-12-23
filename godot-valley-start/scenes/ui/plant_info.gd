extends PanelContainer

var plant_res: PlantResource;

func setup(res: PlantResource):
	var icon = $HBoxContainer/IconTexture
	var label = $HBoxContainer/VBoxContainer/Label
	plant_res = res
	icon.texture = plant_res.icon_texture
	label.text = plant_res.plant_name
	update()
	plant_res.connect("changed", death_checker)
	
func update():
	var growth_bar = $HBoxContainer/VBoxContainer/GrowthBar
	var death_bar = $HBoxContainer/VBoxContainer/DeathBar
	
	var growth: float = plant_res.age / plant_res.h_frames * growth_bar.max_value
	var death: float = (1 - (plant_res.life / plant_res.max_life)) * death_bar.max_value
	
	growth_bar.value = growth
	death_bar.value = death
	
func death_checker():
	queue_free()
