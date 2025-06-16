class_name Saver_Loader extends Node

#@onready var jugador = $"../../Player/Jugador"
@export var player = PackedScene

var saved_data = {}

func save_game() -> void:
	var file = FileAccess.open("res://savegame.data", FileAccess.WRITE)
	file.store_var(player.global_position)
	file.store_var(player.life)
	file.close()

func load_game() -> void:
	var file = FileAccess.open("res://savegame.data", FileAccess.READ)
	player.global_position = file.get_var()
	player.life = file.get_var()
	file.close()
