class_name PlayerStateWalking extends StateBase

var input_vector = Vector2.ZERO

@onready var tilt_angle : float = controlled_node.tilt_angle  # Grados de inclinación hacia derecha
#@onready var initial_rotation : float = controlled_node.initial_rotation
@onready var vel_rotation : float = controlled_node.vel_rotation

func _ready() -> void:
	controlled_node.velocity += input_vector
	
func on_physics_process(delta: float) -> void:
	controlled_node.animation.play("move")
	
	#Adquiere input de valores globales
	input_vector = Global.get_input()
	controlled_node.velocity += input_vector * controlled_node.acceleration * delta
	controlled_node.velocity = controlled_node.velocity.limit_length(controlled_node.max_speed)
	
	# Inclinacion de animacion
	if input_vector.x > 0: # derecha
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, tilt_angle, vel_rotation * delta)
	elif !controlled_node.astro_2b.flip_h && input_vector.y > 0: # derecha abajo
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, tilt_angle * 1.5,vel_rotation * delta) 
	elif input_vector.x < 0: # izquierda
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, -tilt_angle, vel_rotation * delta)  
	elif controlled_node.astro_2b.flip_h && input_vector.y > 0: # izquierda abajo
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, (-tilt_angle * 1.5), vel_rotation * delta)
	elif !controlled_node.astro_2b.flip_h && input_vector.y < 0: # arriba derecha
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, (-tilt_angle * 1.3), vel_rotation * delta)
	elif controlled_node.astro_2b.flip_h && input_vector.y < 0: # arriba izquierda
		controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, (tilt_angle * 1.3), vel_rotation * delta)
	#else:
		#controlled_node.astro_2b.rotation = lerp_angle(controlled_node.astro_2b.rotation, initial_rotation, delta * 3)
		## Restablece la inclinación si no se mueve hacia adelante
	
	# Flip
	if controlled_node.velocity.x > 0:
		controlled_node.astro_2b.flip_h = false
	if controlled_node.velocity.x < 0:
		controlled_node.astro_2b.flip_h = true


func on_input(event: InputEvent) -> void:
	if not Input.is_action_pressed("_left") and not Input.is_action_pressed("_right") and not Input.is_action_pressed("_down") and not Input.is_action_pressed("_up"):
		state_machine.change_to("PlayerStateIdle")
