class_name Quest extends QuestManager

#comenzar quest
func start_quest() -> void:
	#se asegura de que esta quest estadisponible
	if quest_status == QuestStatus.availible:
		#actualiza el estado de la quest
		quest_status = QuestStatus.started
		#Muestra en pantalla
		QuestBox.visible = true
		QuestTitle.text = quest_name
		QuestDescription.text = quest_description

#Marca de que se ha alcanzado la meta
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		#actualiza el estado de la quest
		quest_status = QuestStatus.reached_goal
		#Muestra en pantalla el nuevo estado/descripcion y como finalizar
		QuestDescription.text = reached_goal_text

#Finalizacio de la quest
func finish_quest() -> void:
	if quest_status == QuestStatus.reached_goal:
		#actualiza el estado
		quest_status = QuestStatus.finished
		#Actualiza la visivilidad de la quest
		QuestBox.visible = false
		#Recompensa
		GameManager.gold += reward_amount
		GameManager.xp += xp_amount
