#Propiedades del personaje, efectos de items
class_name Player extends CharacterBody2D

#static var current_player: Player = null

"""import de nodos"""
# Tablero
@onready var control_panel_animation: AnimatedSprite2D = $"../GUI/ControlPanel_animation"
## Labels
@onready var life_label: Label = $"../GUI/life_label"
@onready var oxi_label: Label = $"../GUI/oxi_label"
#Animaciones player
@onready var astro_2b = $Astro2b
@onready var animation = $Astro2b/Animation

"""Variables"""
@export_group("Astro Properties")
# Vida
@export var extra_health : int = 0

# Movimimiento
## Velocidad Maxima
var max_speed : int = Global.max_speed
## Aceleracion
var acceleration : int = Global.acceleration
## Friccion
var friction : int = Global.friction

@export_subgroup("Oxygen")
# Oxígeno
@export var extra_oxygen : float = 0
@export var free_oxygen : bool = false

# Velocidad objetivo seteada en cero
var target_velocity = Vector2.ZERO
# input (movimiento)
var input_vector = Vector2.ZERO
# Repulsion
var wall_collision : bool = false
# Inclinacion de animacion
var tilt_angle : float = 0.2  # Grados de inclinación hacia derecha
var initial_rotation : float = 0.0 # Personaje en su rotacion original
var vel_rotation : float = 0.5 # Vel de rotacion

# Camara
var camera_2d: Camera2D
var camera_shake_Noise = FastNoiseLite #Movimiento de camara

#MAquina de estados
#@onready var state_machine: PlayerStateMachine = $StateMachine
#Inventario
@onready var inventory_ui = $Inventory_

"""Funciones"""
func _ready() -> void:
	#Iniciar Maquina de estado
	#state_machine.initialize(self)
	#Seteando este nodo al player del item_list
	GlobalItemList.set_player_reference(self)
	#Camara y efecto
	camera_2d = $"../Camera2D"
	if Player != null:
		camera_shake_Noise = FastNoiseLite.new()
	
	## Sumar salud y oxigeno extra a estadisticas globales
	Global.health += extra_health
	Global.oxygen += extra_oxygen

func _process(_delta: float) -> void:
	#Visibilidad del inventario (verifica por si se clickea boton)
	inventory_ui.visible = GlobalItemList.inventory_visible
	
func _physics_process(_delta):
	move_and_slide()
	
	"""Cheats"""
	if free_oxygen:
		Global.free_oxygen = free_oxygen
	#impulse(delta)
	
	"""Salto"""
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = PUSH * delta

##abrir inventario
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_inventory"):
		#GlobalItemList.inventory_visible = !GlobalItemList.inventory_visible
	#if event.is_action_pressed("esc"):
		#menu.visible = !menu.visible

func use_hotbar_item(slot_index):
	if slot_index < GlobalItemList.hotbar_inventory.size():
		var item = GlobalItemList.hotbar_inventory[slot_index]
		if item != null and item["effect"] != "":
			#usar item en slot
			apply_item_effect(item)
			#Borrar item
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				GlobalItemList.hotbar_inventory[slot_index] = null
				GlobalItemList.remove_item(item["type"], item["effect"])
			GlobalItemList.inventory_updated.emit()
		if item != null and item["effect"] == "":
			GlobalItemList.add_info("Este item no tiene efecto")

#Uso de accesos directos para hotbar
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		for i in range(GlobalItemList.hotbar_size):
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break

#Efecto de aplicaciones de items
func apply_item_effect(item):
	match item["effect"]:
		"velocidad":
			var extra_speed = 150
			max_speed += extra_speed
			#afecta de manera permanente aunque cambie de escenario o muera
			Global.max_speed = max_speed
			GlobalItemList.add_info(str("Velocidad final aumentada en ", extra_speed))
		"inventario":
			GlobalItemList.increase_inventory_size(3)
			GlobalItemList.add_info(str("Inventario aumentado en ", GlobalItemList.inventory.size()))
		_:
			GlobalItemList.add_info(str("no hay efecto para este item"))

#Funcion para generar autodaño
func self_damage() -> void:
	Global.health -= 1
	$Timer.start()

#Funcion para rebote
func impulse(_delta: float) -> void:
	move_and_slide()
	# Calcula la normal en el punto de colision
	var collision_normal = get_wall_normal()
	velocity = velocity.bounce(collision_normal)

# Sacudir camara
func start_camera_shake(intensity : float):
	var camera_offset = camera_shake_Noise.get_noise_1d(Time.get_ticks_msec() * intensity)
	camera_2d.offset.x = camera_offset
	camera_2d.offset.y = camera_offset

## Señales
func _on_area_2d_body_entered(body):
	if body.is_in_group("spike") || body.is_in_group("ship"):
		# Sacudir camara
		var camera_tween = get_tree().create_tween()
		camera_tween.tween_method(start_camera_shake, 2.0, 1.0, 0.5)
		##Repulsion
		wall_collision = true
		velocity = -velocity
		$Timer.start()

func _on_timer_timeout(): #Timer de 1 segundo
	if wall_collision:
		wall_collision = false
	if Global.oxygen < 1:
		self_damage()
