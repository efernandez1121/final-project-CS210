
extends RayCast3D

var current_collider: Object = null

@export var interaction_label: Label  # drag the label into this in the inspector

func _ready():
	set_interaction_text("")

func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			if current_collider != collider:
				set_interaction_text(collider.get_interaction_text())
				current_collider = collider

			if Input.is_action_just_pressed("interact") and current_collider:
				print("RayCast interacting with:", collider.name)
				current_collider.interact()
				set_interaction_text(current_collider.get_interaction_text())
		else:
			clear_interaction()
	else:
		clear_interaction()

func clear_interaction():
	if current_collider:
		current_collider = null
		set_interaction_text("")

func set_interaction_text(text: String):
	if interaction_label == null:
		return
	if text.strip_edges() == "":
		interaction_label.visible = false
	else:
		var key = "E"
		var events = InputMap.action_get_events("interact")
		for event in events:
			if event is InputEventKey:
				key = OS.get_keycode_string(event.physical_keycode)
				break
		interaction_label.text = "Press %s to %s" % [key, text]
		interaction_label.visible = true
