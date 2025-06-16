#Elementos generales (puntos, salud, oxigeno)
extends Node

var score: int = 0
var credits: int = 1
var health : int = 90
var oxygen = 100
var free_oxygen : bool = true

@export_subgroup("Movement")
## Velocidad Maxima
@export var max_speed : int = 90
## Aceleracion
@export var acceleration : int = 200
## Friccion
@export var friction : int = 100
#var character_level : int = 1
#var character_exp : int = 1
#var exp_checkpoints = [0, 100, 200, 400, 800, 1600]
#var last_world_position = Vector2(0,0)

#Gravedad
var gravityX = 0
var gravityY = 0

# Cinturon
var belt = []
var max_belt_size = 5

var input_vector = Vector2.ZERO

#Contador para dialogos
var dialogue_num : int = 0

"""Funciones"""

func _process(delta: float) -> void:
	# Oxigeno
	if free_oxygen && oxygen < 100:
		oxygen += 0.3
	elif !free_oxygen && oxygen > 0:
		oxygen -= 0.04
	else:
		pass
		
#Sistema de dialogos
func dialogue_start() -> void:
	var scene_name = get_tree().current_scene.name
	#Comienzo de partida
	if dialogue_num == 0 && scene_name == "Universe":
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/prueba.dialogue"), "start")
		dialogue_num += 1
	if dialogue_num == 1 && scene_name == "Inside_my_spaceship":
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/prueba.dialogue"), "start_inside")
		dialogue_num += 1
	

#Agregar item al cinturon
func add_item_to_belt(item):
	for i in range(min(belt.size(), max_belt_size)):
		if belt[i] == null:
			belt[i] = item
			return
	if belt.size() < max_belt_size:
		belt.append(item)
	else:
		print("cinturon lleno")

#detectar movimiento
func get_input():
	input_vector.x = int(Input.is_action_pressed("_right")) - int(Input.is_action_pressed("_left"))
	input_vector.y = int(Input.is_action_pressed("_down")) - int(Input.is_action_pressed("_up"))
	return input_vector.normalized()

#mostrar cinturon
func get_belt():
	return belt
