extends Node
@onready var sprite:Sprite2D = $Sprite2D
@onready var door: Sprite2D = $Interactive/Door
@onready var broken_module: Sprite2D = $Interactive/broken_module

var quest: Quest = GameManager.actual_quest


func _door_on_area_2d_mouse_entered() -> void:
	door.material =  load("res://FXs/Material_select.tres")

func _door_on_area_2d_mouse_exited() -> void:
	door.material =  null

func _broken_module_on_area_2d_mouse_entered() -> void:
	broken_module.material =  load("res://FXs/Material_select.tres")
	#if quest != null:
		#if quest.quest_status == quest.QuestStatus.availible:
			#quest.reached_goal()
			#queue_free()

func _broken_module_on_area_2d_mouse_exited() -> void:
	broken_module.material =  null
