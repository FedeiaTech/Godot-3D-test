class_name QuestManager extends Node2D

#Elementos UI que mostrara en pantalla
@onready var QuestBox: CanvasLayer = GameManager.get_node('QuestBox')
@onready var QuestTitle: RichTextLabel = GameManager.get_node('QuestBox').get_node('QuestTitle')
@onready var QuestDescription: RichTextLabel = GameManager.get_node('QuestBox').get_node('QuestDescription')

@export_group("Quest Settings")
@export var quest_name: String #nombre del quest
@export var quest_description: String #descripcion del quest
@export var reached_goal_text: String #texto descrtiptivo al alcanzar la meta

"""Todos los Quest Status"""
enum QuestStatus {
	availible,
	started,
	reached_goal,
	finished
}

##Quest Status
@export var quest_status: QuestStatus = QuestStatus.availible

@export_group("Reward Settings")
@export var reward_amount: int #recompensa en valores
@export var xp_amount: int #resompensa de experiencia
