extends Control

@onready var grid_container = $GridContainer

#Arrastrar y soltar
var dragged_slot = null

func _ready():
	GlobalItemList.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

#actualizar inventario
func _on_inventory_updated():
	# Limpia contenedor de slots antes de recargar
	clear_grid_container()
	#Agregar slot por cada posicion del inventario
	for item in GlobalItemList.inventory:
		var slot = GlobalItemList.inventory_slot_scene.instantiate()
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

# Limpia contenedor de slots antes de recargar
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
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

#Obtiene la posicion del muse en las coordenadas del grid_container
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

func get_slot_index(slot : Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot: 
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
		if GlobalItemList.swap_inventory_items(slot1_index, slot2_index):
			#GlobalItemList.add_info(str("Intercambiando items: ", slot1, slot2_index))
			_on_inventory_updated()
