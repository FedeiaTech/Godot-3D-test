class_name TimeSystem extends Node

@export var date_time : DateTime
@export var ticks_pr_second : int = 20
# 20: en 3 min pasara una hora en el juego aprox.
# 30: en 2 min pasara una hora
# 60: en 1 min pasara una hora

func _process(delta: float) -> void:
	date_time.increase_by_sec(delta * ticks_pr_second)
