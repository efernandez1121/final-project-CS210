extends PanelContainer

const Slot = preload("res://inventory/slot.tscn")

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_grid_container)
	populate_grid_container(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_grid_container)




func populate_grid_container(inventory_data: InventoryData) -> void:
	for child in grid_container.get_children():
		child.queue_free()
	for slot_data in inventory_data.slot_datas():
		var slot = Slot.instantiate()
		grid_container.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
		
