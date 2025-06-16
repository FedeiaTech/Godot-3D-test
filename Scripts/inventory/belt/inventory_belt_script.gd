extends Control

var slots = [null, null, null, null]
@onready var slot_images = [$Control/Slot_1/Slot_1_img, $Control/Slot_2/Slot_2_img, $Control/Slot_3/Slot_3_img, $Control/Slot_4/Slot_4_img]
@onready var hotbar_container: HBoxContainer = $HBoxContainer

#Arrastrar y soltar
var dragged_slot = null

func _ready() -> void:
	#1
	#slots = Global.get_belt()
	#update_inventory_UI_belt()
	#2
	GlobalItemList.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("slot_1"):
		#use_item(0)
	#elif event.is_action_pressed("slot_2"):
		#use_item(1)
	#elif event.is_action_pressed("slot_3"):
		#use_item(2)
	#elif event.is_action_pressed("slot_4"):
		#use_item(3)

#func use_item(slot_index):
	#if slots[slot_index] != null:
		#slots[slot_index].use()
		#slots[slot_index] = null
		#slot_images[slot_index].texture = null
		#update_inventory_UI_belt()
	#else:
		#return

#func update_inventory_UI_belt():
	#slots = Global.get_belt()
	#for i in range(len(slots)):
		##print("actualizando slot ", i)
		#if slots[i] != null:
			##print("se encontro item para slot ", i)
			#slot_images[i].texture = slots[i].item_texture

func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(GlobalItemList.hotbar_size):
		var slot = GlobalItemList.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		if GlobalItemList.hotbar_inventory[i] != null:
			slot.set_item(GlobalItemList.hotbar_inventory[i])
		else:
			slot.set_empty()
		slot.update_assignament_status()

func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()

#Almacenar referecia de item arrastrado
func _on_drag_start(slot_control : Control):
	dragged_slot = slot_control
	#GlobalItemList.add_info(str("Arrastrando items del slot ", dragged_slot))

func _on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null

#Obtiene la posicion del mouse en las coordenadas del hotbar_container
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

func get_slot_index(slot : Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot: 
			#Slot valido encontrado
			return i
	#Slot invalido
	return -1

func drop_slot(slot1 : Control, slot2 : Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		GlobalItemList.add_info("Slot invalido")
		return
	else:
		if GlobalItemList.swap_hotbar_items(slot1_index, slot2_index):
			#GlobalItemList.add_info(str("Intercambiando items: ", slot1, slot2_index))
			_update_hotbar_ui()
