extends Node

var gold = 50
var xp = 100

var actual_quest

func _process(delta: float) -> void:
	$InfoCanvas/Gold.text = str(gold)
	$InfoCanvas/Xp.text = str(xp)
