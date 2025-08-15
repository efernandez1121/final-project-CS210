extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	if item_data == null:
		return

	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
	else:
		quantity_label.hide()
		
func populate_grid_container(slot_datas: Array[SlotData]) -> void:
	$GridContainer.clear() 

	for i in slot_datas.size():
		var slot_ui = preload("res://test_inv.tres").instantiate() 
		slot_ui.set_slot_data(slot_datas[i])
		slot_ui.slot_clicked.connect(func(index, button): emit_signal("inventory_interact", self, i, button))
		$GridContainer.add_child(slot_ui)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index ==MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed(): 
		slot_clicked.emit(get_index(), event.button_index)
