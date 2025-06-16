class_name Universe extends Node2D
@onready var player: Player = $Player


@export var meteor : PackedScene
#Llamamos a los nodos que se van a utilizar asignandole su nombre: tipo y $ubicacion

#Camara
@onready var camera_2d: Camera2D = $Camera2D
#Transicion
@onready var transition = $Settings/Transition_layer/Transition
@onready var color_rect = $Settings/Transition_layer/Transition/ColorRect
#Labels de estado - oxigeno y vida
@onready var life_label: Label = $GUI/life_label
@onready var oxi_label: Label = $GUI/oxi_label

#Items
@onready var items: Node2D = $Enviroment/Items/Custom_items
@onready var spawn_area_items: Area2D = $Enviroment/Items/SpawnAreaItems
@onready var collision_shape_spawn_items: CollisionShape2D = $Enviroment/Items/SpawnAreaItems/CollisionShape2D

func _ready():
	#Transiciones de escena
	color_rect.show()
	transition.play("Fade_in")
	
	#Iniciar dialogo de prueba
	Global.dialogue_start()
	#if Global.dialogue_num < 1:
		#DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/prueba.dialogue"), "start")
		#Global.dialogue_num += 1
	
	#Colocar items de forma aleatoria
	spawn_random_items(10)
	
	#Habilitar oxigeno
	Global.free_oxygen = false
	
func _process(delta):
	paralax_bg(delta)
	
	## PathSpawn movimiento
	#$Enemies/Spikes/PathSpawn/PathFollow2D.set_progress($Enemies/Spikes/PathSpawn/PathFollow2D.get_progress() * 80 * delta)
	
	"""Label"""
	if player != null:
		life_label.text = "Vida: " + str(Global.health)
		oxi_label.text = "Oxigeno: " + str(int(Global.oxygen))
		game_over()

func game_over() -> void:
	if Global.health <= 0:
		life_label.text = "Game \nOver"
		oxi_label.text = ""
		player.queue_free()

#func _unhandled_key_input(event: InputEvent) -> void:
## Esta función se ejecutará cada vez que se detecte una entrada de teclado
## que no haya sido capturada por otros elementos de la interfaz. 
## El parámetro event contiene información sobre el evento de teclado, 
## como qué tecla se presionó.
	#if event.is_action_pressed("ui_cancel"):
		## verifica si la acción del usuario coincide con la acción definida como 
		## "ui_cancel" en los ajustes de entrada del proyecto.
		#confirmation_modal.customize(
			#"Estas huyendo?",
			#"Si te vas no hay vuelta atrás",
			#"Irse",
			#"Volver"
		#)
		#var is_confirmed = await confirmation_modal.prompt(true)
		## confirmation_modal.prompt(true): Llama al método prompt del objeto 
		## confirmation_modal, mostrándolo en pantalla y pausando el juego. 
		## El parámetro true indica que se debe pausar el juego mientras el modal 
		## está visible.
		## await: La palabra clave await hace que la ejecución de esta línea se 
		##pause hasta que el usuario interactúe con el modal y lo cierre, 
		## ya sea confirmando o cancelando la acción.
		## var is_confirmed: Se almacena el resultado de la llamada a prompt 
		## en la variable is_confirmed. Esta variable será true si el usuario 
		## confirmó la acción.
		#if is_confirmed:
			#get_tree().quit()

#func _on_limits_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("character"):
		#limit_alert.play("modulate_in")
#
#func _on_limits_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("character"):
		#limit_alert.play("modulate_out")

func paralax_bg(delta):
	get_node("Enviroment/Background/ParallaxBackground").scroll_base_offset -= Vector2(1,0) * 8 * delta
	$Enviroment/Background/Planet_1.scroll_base_offset -= Vector2(1,0) * 16 * delta

func _on_spawn_timer_timeout() -> void:
	var meteor_instance = meteor.instantiate()
	#player.global_position = $Enemies/Spikes/PathSpawn/PathFollow2D.global_position
	add_child(meteor_instance)
	meteor_instance.global_position = $Enemies/Spikes/PathSpawn/PathFollow2D.global_position

func get_random_position():
	var area_rect = collision_shape_spawn_items.shape.get_rect()
	var x = randf_range(0, area_rect.position.x)
	var y = randf_range(0, area_rect.position.y)
	return spawn_area_items.to_global(Vector2(x, y))

func spawn_random_items(counts):
	var attemps = 0
	var spawned_counts = 0
	while spawned_counts < counts and attemps < 100:
		var new_position = get_random_position()
		spawn_items(GlobalItemList.spawnable_items[randi() % GlobalItemList.spawnable_items.size()], new_position)
		spawned_counts += 1
		attemps += 1
		
func spawn_items(data, new_position):
	var item_scene = preload("res://Scenes/Inventory/inventory_item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"], data["description"])
	item_instance.global_position = new_position
	items.add_child(item_instance)
	
