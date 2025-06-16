#Items, elementos GUI
#Estados de interaccion e informacion en pantalla
extends CanvasLayer

#@onready var confirmation_modal: Confirmation_Modal = $"../Popups/Confirmation_Modal"
@onready var saver_loader: Saver_Loader = $"../Settings/Saver_Loader"
@onready var control_panel_animation: AnimatedSprite2D = $ControlPanel_animation
@onready var player: CharacterBody2D = $"../Player"

#@onready var camera_2d: Camera2D = $"../Camera2D"
#@onready var camera_2d: Camera2D = $"../Player/Jugador/Camera2D"
@onready var interact_ui: CanvasLayer = $Interact_UI
@onready var interact_label: Label = $Interact_UI/InteractLabel
@onready var info_text: RichTextLabel = $InfoText

var interact_text_label

func _ready() -> void:
	control_panel_animation.play("default_panel")

func _process(_delta: float) -> void:
	if Global.oxygen < 60:
		control_panel_animation.play("alert_panel")
	else:
		control_panel_animation.play("default_panel")
	
	if GlobalItemList.player_in_range_info:
		interact_ui.visible = true
		interact_label.text = str(GlobalItemList.interact_text)
	else:
		interact_ui.visible = false
	#Panel de interacciones
	update_interact_ui()
	
	#info_Text
	var detailed_info = ""
		#cuenta las lineas que tiene el texto de largo
	var line_count = info_text.get_line_count()
	for i in GlobalItemList.info_text:
		detailed_info += i + "\n"
	info_text.text = detailed_info
		#Se desplaza a la ultima linea
	info_text.scroll_to_line(line_count - 1)
	
	
"""Botones"""
# Save
func _on_b_save_pressed() -> void:
	saver_loader.save_game()
# Load
func _on_b_load_pressed() -> void:
	saver_loader.load_game()

# Reiniciar nivel
func _on_b_restart_pressed():
	get_tree().reload_current_scene()
	
# Pantalla completa
func _on_b_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func update_interact_ui():
	if GlobalItemList.hover_button_panel:
		interact_ui.visible = true
		interact_label.text = str(GlobalItemList.interact_text)
	else:
		interact_ui.visible = false
	
#Boton de inventario
func _on_b_inventory_mouse_entered() -> void:
	GlobalItemList.hover_button_panel = true
	GlobalItemList.interact_text = str(GlobalItemList.interact_Label["inventory"])

func _on_b_inventory_mouse_exited() -> void:
	GlobalItemList.hover_button_panel = false

func _on_b_inventory_pressed() -> void:
	GlobalItemList.inventory_visible = !GlobalItemList.inventory_visible
