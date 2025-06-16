extends Area2D

var speed = 5

func _process(delta: float) -> void:
	global_position.x += speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		queue_free()
