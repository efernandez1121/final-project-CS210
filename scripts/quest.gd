extends QuestManager

class_name QuestQueue

var queue := []
var is_displaying := false

signal quest_displayed(quest)
signal quest_finished(quest)

func enqueue_quest(quest_data):
	queue.push_back(quest_data)
	if not is_displaying:
		_display_next_quest()

func _display_next_quest():
	if queue.is_empty():
		is_displaying = false
		return
	is_displaying = true
	var quest = queue.pop_front()
	emit_signal("quest_displayed", quest)

func on_quest_popup_finished():
	is_displaying = false
	emit_signal("quest_finished", null)
	_display_next_quest()


func _on_quest_displayed(quest):
	$QuestBox.visible = true
	$QuestTitle.text = quest.quest_name
	$QuestDescription.text = quest.quest_description
	await get_tree().create_timer(4.0).timeout  # Display time
	$QuestBox.visible = false
	$QuestQueue.on_quest_popup_finished()
