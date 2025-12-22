extends PanelContainer

var plant_res: PlantResource;

func setup(res: PlantResource):
	if res == null:
		print("res is null")
		return
	plant_res = res
	#update()
	
func update():
	var icon = $HBoxContainer/IconTexture
	var label = $HBoxContainer/VBoxContainer/Label
	var growth_bar = $HBoxContainer/VBoxContainer/GrowthBar
	var death_bar = $HBoxContainer/VBoxContainer/DeathBar
	
	var growth: float = plant_res.age / plant_res.h_frames * growth_bar.max_value
	var death: float = (1 - (plant_res.life / plant_res.max_life)) * death_bar.max_value
	
	icon.texture = plant_res.texture
	label.text = plant_res.plant_name
	growth_bar.value = growth
	death_bar.value = death
