extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, int, button: int)

@export var head: SlotData = null
@export var tail: SlotData = null

func add_item(item: ItemData, quantity: int = 1) -> void:
	var new_slot := SlotData.new()
	new_slot.item_data = item
	new_slot.quantity = quantity

	if head == null:
		head = new_slot
		tail = new_slot
	else:
		tail.next = new_slot
		new_slot.prev = tail
		tail = new_slot

func remove_item(item_name: String) -> bool:
	var current = head
	while current != null:
		if current.item_data.name == item_name:
			if current.prev != null:
				current.prev.next = current.next
			else:
				head = current.next
			if current.next != null:
				current.next.prev = current.prev
			else:
				tail = current.prev
			return true
		current = current.next
	return false
	
const MAX_SLOTS = 4

func slot_datas() -> Array[SlotData]:
	var items: Array[SlotData] = []
	var current = head
	while current != null:
		items.append(current)
		current = current.next
	while items.size() < MAX_SLOTS:
		items.append(SlotData.new())
	return items
	
func get_slot_at(index: int) -> SlotData:
	var i = 0
	var current = head
	while current != null and i < index:
		current = current.next
		i += 1
	return current
func grab_slot_data(index: int) -> SlotData:
	var slot_data = get_slot_at(index)

	if slot_data and slot_data.item_data != null:
		var grabbed = SlotData.new()
		grabbed.item_data = slot_data.item_data
		grabbed.quantity = slot_data.quantity

		slot_data.item_data = null
		slot_data.quantity = 0
		
		inventory_updated.emit(self)
		return grabbed

	return null
	
	

func pick_up_slot_data(slot_data:SlotData) -> bool: 
	var i = 0
	var current = head
	while current != null:
		if current.item_data == null:
			current.item_data = slot_data.item_data
			current.quantity = slot_data.quantity
			inventory_updated.emit(self)
			return true
		current = current.next
		i += 1

	if i < MAX_SLOTS:
		add_item(slot_data.item_data, slot_data.quantity)
		inventory_updated.emit(self)
		return true

	return false

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
