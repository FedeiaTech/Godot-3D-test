extends Node2D

var item_id = 1

func use():
	Global.oxygen += 50
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass
