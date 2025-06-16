extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var input_vector = Vector2.ZERO

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func get_input():
	velocity = Vector2.ZERO
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction.length() > 0:
		# Normaliza el vector de dirección.
		# Esto es crucial para el movimiento en 8 direcciones, ya que asegura
		# que la velocidad diagonal no sea más rápida que la horizontal o vertical.
		# Sin esto, moverse en diagonal sería un 41% más rápido (raíz cuadrada de 2).
		input_direction = input_direction.normalized()

		# Calcula la velocidad final multiplicando la dirección normalizada por la SPEED.
		velocity = input_direction * SPEED
