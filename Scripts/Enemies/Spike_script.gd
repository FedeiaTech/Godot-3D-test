extends CharacterBody2D

@onready var Sprite: AnimatedSprite2D = $Sprite2D

const MOVEMENT : float = 0
const DAMAGE:int = 1
const IMPULSE_FORCE: int = 200
const MASS: float = 5.5

var player = null
var player_collision : bool = false

func _ready():
	#onready al nodo jugador al iniciarse - corregir 
	#player = get_node("Main/Player/Jugador")
	#movimiento inicial
	velocity.x = Global.gravityX
	velocity.y = Global.gravityY
	
func _physics_process(delta):
	if player != null && player_collision:
		impulse(delta)
	move_and_slide()


# Ataque
func attack(damage:int) -> void:
	if Global.health > 0:
		Global.health -= damage

func impulse(_delta: float) -> void:
	move_and_slide()
	# Calcula la normal en el punto de colision
	var collision_normal = get_wall_normal()
	if player != null:
		#var direction = global_position.direction_to(player.global_position)
		if player_collision:
			velocity += velocity.bounce(collision_normal) - player.velocity / MASS
	

func _on_area_2d_body_entered(body):
	if body.name == "Jugador":
		##Activar colision
		player_collision = true
		##Daño al tocar personaje
		attack(DAMAGE)
		#sprite.set_texture(hited_sprite)
		##Cooldown
		$Timer.start()

func _on_area_2d_body_exited(_body):
	player_collision = false 

#func _on_timer_timeout():
	# Daño constante al personaje cada un segundo
	#if player_collision && player != null: #player != null - evita errores
	#	attack(player, DAMAGE)
	#if sprite.get_texture() == hited_sprite:
	#	sprite.set_texture(original_texture)


func _on_area_2d_mouse_entered() -> void:
	Sprite.material =  load("res://FXs/Material_select.tres")


func _on_area_2d_mouse_exited() -> void:
	Sprite.material =  null
