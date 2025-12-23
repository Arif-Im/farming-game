extends Control

@onready var v_box_container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

var plant_info = preload("res://scenes/ui/plant_info.tscn")
var plants: Dictionary[PlantResource, PanelContainer]

func add(res: PlantResource):
	var plant = plant_info.instantiate()
	plant.setup(res)
	v_box_container.add_child(plant)
	plants[res] = plant
	update()
	
func update():
	for plant in v_box_container.get_children():
		plant.update()
		
func remove(res: PlantResource):
	var plant = plants[res]
	plants.erase(res)
	plant.queue_free()
