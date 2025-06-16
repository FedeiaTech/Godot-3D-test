extends Area2D

@export var quest: Quest

"""Quests"""
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		#Si la quest esta disponible
		if quest.quest_status == quest.QuestStatus.availible:
			#comienza la quest
			quest.start_quest()
		#Si se ha llegado a la meta de finalizacion de la quest
		if quest.quest_status == quest.QuestStatus.reached_goal:
			#finaliza la quest
			quest.finish_quest()
		


func _on_area_2d_mouse_entered() -> void:
	quest.reached_goal()
	#if quest.quest_status == quest.QuestStatus.availible:
		#print("holaa")
		#quest.reached_goal()
		#queue_free()
