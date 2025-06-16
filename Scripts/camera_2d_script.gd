extends Node2D

#Nodo a seguir con la camara
@export var follow_node: Node2D

#@onready var player: CharacterBody2D = $".."
@onready var camera: Camera2D = $"."
@onready var universe: Node2D = $".."
@onready var player: Player = $"../Player"

var last_known_player_position

func _process(_delta: float) -> void:
	if Player != null && Global.health > 0:
		global_position = follow_node.global_position
		last_known_player_position = global_position
	else:
		# Almacenar la última posición conocida
		#last_known_player_position = global_position
		# Detener el seguimiento (ajusta esto según tu implementación)
		# Por ejemplo, desactiva un nodo que mueve la cámara
		global_position = last_known_player_position
		# ... otras acciones para detener el seguimiento
