"""
Este código implementa un modal de confirmación para salir del juego. 
El modal contiene un mensaje, un botón de confirmación y un botón de cancelación. 
Cuando se presiona el botón de confirmación, se cierra el modal y 
se emite una señal confirmed con el valor true. 
Cuando se presiona el botón de cancelación, se cierra el modal y 
se emite la señal confirmed con el valor false.

En la escena principal, se captura el evento de teclado para la acción "ui_cancel". 
Si se presiona esta acción, se muestra el modal de confirmación con el mensaje 
adecuado. Se espera la respuesta del modal y, si se confirma, se cierra el juego.
"""

class_name Confirmation_Modal extends CanvasLayer
#Define una nueva clase que hereda de Control. 
#Lo convierte un elemento visual que se puede añadir a la escena.

signal confirmed(is_confirmed:bool)
#Declara una señal "Confirmed" y se emitirá cuando el 
#usuario confirme o cancele la acción

"""Imports"""
# Labels
@onready var header_label: Label = %Header_label
@onready var message_label = %Message_label2
# Botones
@onready var confirm_button = %Confirm_Button
@onready var cancel_button = %Cancel_Button
# Player
@onready var player: CharacterBody2D = $"../../Player"

var is_open:bool = false #Si el modal esta abierto o no
var _should_unpause: bool = false #Despausar juego si se cierra el modal

func _ready():
	set_process_unhandled_key_input(false)
	# Desactiva el procesamiento de eventos de teclado no manejados
	if !confirm_button:
		confirm_button.pressed.connect(_on_confirm_button_pressed)
	if !cancel_button:
		cancel_button.pressed.connect(_on_cancel_button_pressed)
	# Si los botones de confirm/canc existen, conectan su señal pressed a la función
	hide()	# Oculta el modal

#func _process(_delta: float) -> void:
	#if player != null:
		#global_position = player.global_position

func _on_confirm_button_pressed() -> void:
# Función llamada cuando se presiona el botón de confirmación.
	confirm()
	
func _on_cancel_button_pressed() -> void:
# Función llamada cuando se presiona el botón de cancelación.
	cancel()
	
func _unhandled_key_input(event: InputEvent) -> void:
	# Si se presiona la acción "ui_cancel", 
	# llama a la función cancel para cerrar el modal sin confirmar.
	if event.is_action_pressed("ui_cancel"):
		cancel()

func prompt(pause: bool = false) -> bool:
	_should_unpause = (get_tree().paused == false) and pause
	# Si el juego no está pausado y pause es true, establece _should_unpause en true
	if pause:
		get_tree().paused = true # Si es true pausa el juego
	show() # Muestra el modal.
	is_open = true # Está abierto ahora es true
	set_process_unhandled_key_input(true)
	# Activa procesamiento de eventos de teclado no manejados
	var is_confirmed = await confirmed
	# spera a que se emita la señal confirmed y 
	# devuelve el valor booleano que se pasó a la señal.
	return is_confirmed # Devuelve el valor de is_confirmed

"""Instanciacion del contenido del modal"""
func customize(header: String, message: String, confirm_text: String = "Si",
 cancel_text: String = "No") -> Confirmation_Modal:
	header_label.text = header # Establece el texto del encabezado del modal.
	message_label.text = message # Establece el texto del mensaje del modal.
	confirm_button.text = confirm_text # Establece el texto del boton confirmar.
	cancel_button.text = cancel_text # Establece el texto del boton confirmar.
	
	return self # Devuelve la instancia del modal.

func close(is_confirmed: bool = false) -> void:
# Cierra el modal, llamando a confirm si is_confirmed es true
# o a cancel si is_confirmed es false.
	if is_confirmed:
		confirm()
	else:
		cancel()
		
func confirm() -> void: # Cierra el modal con confirmación.
	_close_modal(true)

func cancel() -> void: # Cierra el modal sin confirmación.
	_close_modal(false)

func _close_modal(is_confirmed: bool) -> void:
# Función privada que cierra el modal,
# emite la señal confirmed y despausa el juego si es necesario.
	set_process_unhandled_key_input(false)
	confirmed.emit(is_confirmed)
	set_deferred("is_open", false)
	hide()
	if _should_unpause:
		get_tree().paused = false
