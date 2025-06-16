class_name SceneTrigger extends Area2D

@export var connected_scene: String #nombre de la escena a cambiar

func _on_body_entered(body) -> void:
	if body is Player:
		scene_manager.initial_scene = get_tree().current_scene.name
		print("Escena anterior: ", scene_manager.initial_scene)
		scene_manager.change_scene(get_owner(), connected_scene)
