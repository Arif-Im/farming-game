extends Control

var plant_info = preload("res://scenes/ui/plant_info.tscn")

var plants: Array[PlantResource]

func add(res: PlantResource):
	if plant_info == null:
		print("plant info null")
		return
	var plant = plant_info.instantiate()
	plant.setup(res)
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(plant)
	plants.append(res)
	update(res)
	
func update(res: PlantResource):
	for plant in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		plant.update()
