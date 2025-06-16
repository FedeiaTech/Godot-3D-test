class_name CantScape extends Node

@onready var label: Label = $Label
@onready var animation: AnimationPlayer = $Label/Animation

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		label.visible = true
		animation.play("Opacity")
		$Timer.start()

func _on_timer_timeout() -> void:
	label.visible = false
