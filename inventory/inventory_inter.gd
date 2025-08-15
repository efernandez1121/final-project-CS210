extends Control

var grabbed_slot_data: SlotData
var external_inventory_owner

@onready var panel_container: PanelContainer = $PanelContainer
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var external_inventory: PanelContainer = $ExternalInventory

func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() +Vector2(5, 5)
		
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	panel_container.set_inventory_data(inventory_data) 
	
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)

		[_, MOUSE_BUTTON_LEFT]:
			var target_slot = inventory_data.get_slot_at(index)

			if target_slot == null:
				return

			if target_slot.item_data == null:
				# Place into empty
				target_slot.item_data = grabbed_slot_data.item_data
				target_slot.quantity = grabbed_slot_data.quantity
				grabbed_slot_data = null
			else:
				# Swap items
				var temp_item = target_slot.item_data
				var temp_quantity = target_slot.quantity

				target_slot.item_data = grabbed_slot_data.item_data
				target_slot.quantity = grabbed_slot_data.quantity

				grabbed_slot_data.item_data = temp_item
				grabbed_slot_data.quantity = temp_quantity

			inventory_data.inventory_updated.emit(inventory_data)

	update_grabbed_slot()
	
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
		
func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_inventory.show() 
	
func clear_external_inventory(_external_inventory_owner = null) -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		external_inventory.hide() 
		external_inventory_owner = null
	
	
