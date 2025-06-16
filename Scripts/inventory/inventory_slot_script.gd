### Inventory_Slot_script.gd
extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var item_description = $UsagePanel/ItemDescription
@onready var use_button: Button = $UsagePanel/UseButton
@onready var hotbar_button: Button = $UsagePanel/HotbarButton
@onready var outer_border: ColorRect = $OuterBorder

#Señales
signal drag_start(slot)
signal drag_end()

# Interacciones de mouse con Item Slot
var item = null
var slot_index = -1
var is_assigned = false

# Funciones de procesos de item slot
## Set index
func set_slot_index(new_index):
	slot_index = new_index
	
## Vaciar item slot
func set_empty():
	icon.texture = null
	quantity_label.text = ""
	
## Setear item
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"] 
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else: 
		item_effect.text = ""
	if item["description"] != "":
		item_description.text = str(" ", item["description"])
	else: 
		item_description.text = ""
	update_assignament_status()

#Actualizar estado de asignacion en hotbar
func update_assignament_status():
	is_assigned = GlobalItemList.is_item_assigned_to_hotbar(item)
	#if is_assigned:
		#GlobalItemList.add_info("Demasiados objetos en el cinturón")
	#else:
		#GlobalItemList.add_info("Agregado al cinturón")


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited():
	details_panel.visible = false

func _on_drop_button_pressed():
	if item != null:
		var drop_position = GlobalItemList.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(GlobalItemList.player_node.rotation)
		GlobalItemList.drop_item(item, drop_position + drop_offset)
		GlobalItemList.remove_item(item["type"], item["effect"])
		GlobalItemList.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false

func _on_use_button_pressed() -> void:
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if GlobalItemList.player_node:
			GlobalItemList.player_node.apply_item_effect(item)
			GlobalItemList.remove_item(item["type"], item["effect"])
			GlobalItemList.remove_hotbar_item(item["type"], item["effect"])
		else:
			GlobalItemList.add_info(str("Player no pudo encontrarse"))
	else:
		use_button.disabled = true

func _on_hotbar_button_pressed() -> void:
	if item != null:
		if is_assigned:
			GlobalItemList.unassign_hotbar_item(item["type"], item["effect"])
			is_assigned = false
			GlobalItemList.add_info("Objeto quitado del cinturon")
		else:
			GlobalItemList.add_item(item, true)
			is_assigned = true
			GlobalItemList.add_info("Objeto agregado al cinturón")
		update_assignament_status()
#if is_assigned:
		#GlobalItemList.add_info("Demasiados objetos en el cinturón")
	#else:
		#GlobalItemList.add_info("Agregado al cinturón")

#Eventos al presionar el item
func _on_item_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#Panel de uso
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
				if usage_panel.visible:
					details_panel.visible = false
					if item["effect"] != "":
						use_button.disabled = false
					else:
						use_button.disabled = true
				else:
					details_panel.visible = true
		#Arrastrar item
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
