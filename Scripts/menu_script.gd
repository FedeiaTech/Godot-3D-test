extends Control

@onready var transition = $Transition
@onready var InfoCanvas: CanvasLayer = GameManager.get_node('InfoCanvas')

var prueba2 = preload("res://Scenes/LevelManager/Universe.tscn")

func _on_ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
func _on_start_b_pressed():
	transition.play("Fade_out")
	
func _on_transition_animation_finished(_transition):
	get_tree().change_scene_to_packed(prueba2)
	InfoCanvas.visible = true
	# o sin preload:
	# get_tree().change_scene_to_file("res://Escenas/Prueba2.tscn")
	
func _on_quit_b_pressed():
	get_tree().quit()
