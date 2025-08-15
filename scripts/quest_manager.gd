extends Node3D
class_name QuestManager


@onready var QuestBox: CanvasLayer = get_node('QuestBox')
@onready var QuestTitle: RichTextLabel = get_node('QuestTitle')
@onready var QuestDescription: RichTextLabel = get_node('QuestDescription')

@export_group("Quest Settings")
@export var quest_name: String
@export var quest_description: String
@export var reached_goal_text: String

enum QuestStatus {
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status: QuestStatus = QuestStatus.available
