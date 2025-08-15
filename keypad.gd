@tool
extends Node3D

var password_access := {
	"9217": "door",
}

var is_input_locked := false
var password := ""

signal on_correct_password(area: String)
signal on_wrong_password(password: String)
signal on_clear_password(password: String)
signal on_keypad_press(password: String)

@onready var keys = $Key
@onready var password_label = get_node("PasswordSubviewport/PasswordLabel")

func _ready():
	if password_label == null:
		push_error("PasswordLabel NOT FOUND in Keypad scene!")
	else:
		print("PasswordLabel FOUND:", password_label)
		password_label.text = "READY"

	for child in keys.get_children():
		if child is StaticBody3D and child.has_signal("on_interact"):
			child.connect("on_interact", Callable(self, "on_button_interact"))

	if password_label:
		password_label.text = ""

func on_button_interact(value: String) -> void:
	if is_input_locked:
		return

	is_input_locked = true

	match value:
		".":
			if password_access.has(password):
				var area = password_access[password]
				show_message("Access granted to " + area)
				emit_signal("on_correct_password", area)
			else:
				show_message("Access denied")
				emit_signal("on_wrong_password", password)
			password = ""
		"C":
			emit_signal("on_clear_password", password)
			password = ""
			show_message("")
		_:
			if password.length() < 8:
				password += value
				emit_signal("on_keypad_press", password)

	if password_label:
		password_label.text = password

	await get_tree().create_timer(0.3).timeout
	is_input_locked = false

func show_message(msg: String):
	if password_label:
		password_label.text = msg
