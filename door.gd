extends Interactable

enum STATE {
	OPEN,
	CLOSED
}

var state = STATE.CLOSED
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(_on_AnimationPlayer_animation_finished)

func get_interaction_text() -> String:
	if state == STATE.OPEN:
		return "to close door"
	return ""

func interact():
	if state == STATE.OPEN:
		close()

func open():
	if state == STATE.OPEN:
		return
	animation_player.play("door_open")

func close():
	if state == STATE.CLOSED:
		return
	animation_player.play_backwards("door_open")

func _on_AnimationPlayer_animation_finished(anim_name: StringName) -> void:
	if state == STATE.OPEN:
		state = STATE.CLOSED
	else:
		state = STATE.OPEN
