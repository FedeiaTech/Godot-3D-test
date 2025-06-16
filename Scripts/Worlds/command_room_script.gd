class_name command_room extends Node2D

@onready var player: Player = $Player
@onready var door: Marker2D = $EntranceMarkers/Door
@onready var menu: menu_popup = $Popups/Menu

#Transicion de escena
@onready var transition = $Settings/Transition_layer/Transition
@onready var color_rect = $Settings/Transition_layer/Transition/ColorRect

#Labels de estado - vida y oxigeno
@onready var life_label: Label = $GUI/life_label
@onready var oxi_label: Label = $GUI/oxi_label

func _ready() -> void:
	#Escena de Dialogo
	Global.dialogue_start()
	#Efecto transicion
	color_rect.show()
	transition.play("Fade_in")
	#Señal de prueba - solo guarda localizacion en variable global
	scene_manager.connect("ref_location", set_ref_location)
	#posicionar personaje en la puerta
	player.global_position = door.global_position
	#Girar personaje
	player.astro_2b.flip_h = true
	#Habitacion con oxigeno
	Global.free_oxygen = true

func _process(_delta: float) -> void:
	if player != null:
		life_label.text = "Vida: " + str(Global.health)
		oxi_label.text = "Oxigeno: " + str(int(Global.oxygen))

func set_ref_location(): #funcion que rellena localizacion
	scene_manager.new_location = door

func _input(event: InputEvent) -> void:
	#Abrir menu de escape
	if event.is_action_pressed("esc"):
		menu.visible = !menu.visible
