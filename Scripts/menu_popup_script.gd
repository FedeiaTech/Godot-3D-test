class_name menu_popup extends CanvasLayer

@onready var menu: menu_popup = $"."

# Botones
@onready var confirm_button: Button = $Modal/Magin_Container/VBoxContainer/HBoxContainer/Confirm_Button
@onready var cancel_button: Button = $Modal/Magin_Container/VBoxContainer/HBoxContainer/Cancel_Button


func _process(_delta: float) -> void:
	if menu.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
func _on_confirm_button_pressed() -> void:
	get_tree().quit()

func _on_cancel_button_pressed() -> void:
	get_tree().paused = false
	menu.visible = false

#Presionar tecla escape con menu abierto despausa el juego
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_tree().paused = false
