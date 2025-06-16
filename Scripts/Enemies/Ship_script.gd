extends CharacterBody2D

"""Imports"""
@onready var sprite:Sprite2D = $Nave2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_sprite: AnimationPlayer = $AnimatedSprite2D/Animation_Sprite
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

"""Variables"""
@export_category("Variables")
# Velocidad
@export var SPEED:int = 40
# Daño
@export var DAMAGE:int = 1
# Masa
@export var MASS: float = 2.3
# Vida
@export var life:int = 2
# direccion
var direction = null
# Jugador
var player = null
var player_collision : bool = false

"""Funciones"""
func _ready():
	player = get_node("/root/Level/Player/Jugador")

func _physics_process(_delta):
	if player != null:
		if !player_collision:
			follow()
			move_and_slide()
			death()
		else:
			#impulse()
			flee()

# Movimiento
func follow():
	direction = (global_position.direction_to(player.global_position))
	velocity = direction * SPEED

func flee():
	direction = -(global_position.direction_to(player.global_position))
	velocity = direction * SPEED * 2

# Rebote
func impulse() -> void:
	# Calcula la normal en el punto de colision
	var collision_normal = get_wall_normal()
	if player != null && player_collision:
		direction = -(global_position.direction_to(player.global_position))
		velocity = velocity.bounce(collision_normal) - player.velocity / MASS
	if life <= 1:
				animation_sprite.play("alert_vibration")

# Ataque
func attack(damage:int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(setShader_blinkIntensity, 0.45, 0.0, 0.5)
	
	# Particulas
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
	
	if Global.health > 0:
		Global.health -= damage

#Auto-daño
func self_damage(damage: int) -> void:
	if life > 0:
		life -= damage

# Muerte
func death() -> void:
	if life <= 0:
		queue_free()

# Efectos visuales
## Shader blink
func setShader_blinkIntensity(newValue : float):
	if animated_sprite_2d != null:
		animated_sprite_2d.material = load("res://FXs/Blink_material.tres")
		animated_sprite_2d.material.set_shader_parameter("blink_intensity", newValue)

# Colision
func _on_area_2d_body_entered(body):
	if body.name == "Jugador" && !player_collision:
		player_collision = true
		##Primer daño personaje
		attack(DAMAGE)
		##Autodaño
		self_damage(DAMAGE)
		# Daño de espinas
		#$Timer.start()
		$Restore.start()
		
	if body.is_in_group("spike"):
		impulse()
		
		$Restore.start()
		
# Descolision
func _on_area_2d_body_exited():
	#player_collision = false
	$Restore.start() 

# Tiempo
func _on_timer_timeout(): # 1,5 segundos
	if player_collision && player != null: #player != null - evita errores
		## Daño de espinas
		attack(DAMAGE)

func _on_restore_timeout() -> void: # 1 seg
	if player_collision:
		player_collision = false


func _on_area_2d_mouse_entered() -> void:
	if animated_sprite_2d.material == null:
		animated_sprite_2d.material =  load("res://FXs/Material_select.tres")


func _on_area_2d_mouse_exited() -> void:
	animated_sprite_2d.material =  null
