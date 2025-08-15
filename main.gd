extends Node3D

@onready var player: CharacterBody3D = $player
@onready var inventory_inter: Control = $UI/Inventory_Inter
@onready var door = $door  
@onready var keypad = $Keypad  

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_inter.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	keypad.on_correct_password.connect(_on_access_granted)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_inter.visible = not inventory_inter.visible
	if inventory_inter.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if external_inventory_owner and inventory_inter.visible:
		inventory_inter.set_external_inventory(external_inventory_owner)
	else:
		inventory_inter.clear_external_inventory()

func _on_access_granted(area: String) -> void:
	print("Access granted to:", area)

	match area:
		"do":
			door.open()
		_:
			print("No door mapped for:", area)


func _on_guide_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var quest_manager = $QuestManager  # or get_node("QuestManager") depending on your scene
		if quest_manager.quest_status == quest_manager.QuestStatus.available:
			quest_manager.start_quest()
		elif quest_manager.quest_status == quest_manager.QuestStatus.reached_goal:
			quest_manager.finish_quest()
