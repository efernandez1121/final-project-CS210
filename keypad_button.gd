extends Interactable

@export var number := "0" : set = set_number

var interaction_text = "press button"

signal on_interact(value: String)

func set_number(value):
	number = value
	if value and $SubViewport.has_node("Label"):
		$SubViewport/Label.text = str(value)

func get_interaction_text():
	return interaction_text

func interact():
	print("Button pressed:", number)
	emit_signal("on_interact", number)
