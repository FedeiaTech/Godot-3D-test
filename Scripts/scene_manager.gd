class_name SceneManager extends CanvasLayer

#creacion de señal - inside_my_spaceship
signal ref_location

# localizacion de la entrada vacia
var new_location

#String de carpeta base de escenas
var scene_dir_path = "res://Scenes/LevelManager/"

#referencia escena actual
var initial_scene : String

func _ready() -> void:
	#1er forma de emitir una señal
	ref_location.emit()
	#2da forma de emitir una señal
	emit_signal('ref_location')
	
func change_scene(from, to_scene_name: String) -> void:
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)

#funcion de señal emitida
func _on_ref_location() -> void:
	pass # Replace with function body.
