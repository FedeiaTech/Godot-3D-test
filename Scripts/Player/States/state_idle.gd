class_name State_Idle extends StateBase

var player : Player

func start(): #se llama cuando el estado empieza
	#se puede usar para inicializar variables
	player = controlled_node

func end(): #se puede usar para liberar recursos precargados
	pass
	
func on_physics_process(delta: float) -> void:
	#Animacion
	player.animation.play("idle")
	
	#Reduccion progresiva de velocidad
	if player.velocity.length() > (player.friction * delta):
		player.velocity -= player.velocity.normalized() * (player.friction * delta)
	else:
		player.velocity = Vector2.ZERO
	# Restablece la inclinación si no se mueve hacia adelante
	player.astro_2b.rotation = lerp_angle(player.astro_2b.rotation, player.initial_rotation, delta * 3)
		
func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("_left") or Input.is_action_pressed("_right") or Input.is_action_pressed("_down") or Input.is_action_pressed("_up"):
		state_machine.change_to("PlayerStateWalking")
