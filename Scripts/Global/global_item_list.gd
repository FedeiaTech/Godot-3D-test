extends Node

#inventory items
var inventory = []
var inventory_visible = false
@onready var inventory_slot_scene = preload("res://Scenes/Inventory/Inventory_slot.tscn")

# Panel de interactuar
	# Cercania del jugador al item (solo para enviar texto)
	# No se debe usar para areas o globalizara la interaccion
var player_in_range_info = false
	# mouse arriba de un boton GUI
var hover_button_panel = false
	#Ventana de interacciones
var interact_Label = {
	"inventory": "Inventario (I)",
	"take": "Agarrar (E)",
	"use": "Usar (E)",
	"Read": "Leer (E)",
	"talk": "Hablar (E)"
}
var interact_text = ""

# Ventana de eventos con su funcion
var info_text = []
var max_size_info_text = 7

func add_info(text):
	info_text.append(text)
	if info_text.size() > max_size_info_text:
		info_text.remove_at(0)

# Custom signals
signal inventory_updated

#Items comunes spawneables
var spawnable_items = [
	{"type": "Mision", "name": "Pelota de tenis", "effect": "", "texture": preload("res://Assets/Img/Utilities/shoot1.png"), "description": "¿Como llegó esto aquí?"}
]

#Cinturon
var hotbar_size = 4
var hotbar_inventory = []

#Referencias de nodos y escenas
var player_node : Node = null


func _ready() -> void:
	inventory.resize(12)
	hotbar_inventory.resize(hotbar_size)
	add_info("tamaño del inventario: " + str(inventory.size()))

#Agregar item al inventario
func add_item(item, to_hotbar = false):
	var added_to_hotbar = false
	#Agregar al cinturon
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	#Agregar al inventario
	if not added_to_hotbar:
		for i in range(inventory.size()):
			#se fija si el item esta en el inventario comparando tipo y efecto
			if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += item["quantity"]
				#print("item agregado: ", inventory[i]["name"], " x", inventory[i]["quantity"])
				add_info(str("item agregado: ", inventory[i]["name"], " x", inventory[i]["quantity"]))
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				inventory[i] = item
				add_info(str("Nuevo item agregado: ", inventory[i]["name"], " x", inventory[i]["quantity"]))
				#print("NUEVO item agregado: ", inventory[i]["name"], " x", inventory[i]["quantity"])
				inventory_updated.emit()
				return true
		add_info("no hay lugar en el inventario")
		return false

#Borrar item del inventario
func remove_item(item_type, item_effect):
	print("se esta removiendo un item del inventario")
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			print("drop ", inventory[i].name, " x1")
			if inventory[i]["quantity"] <= 0:
				print("se ha removido un item del inventario")
				inventory[i] = null
			inventory_updated.emit()
			inventory_updated.emit()
			return true
	return false

#Ajuste de la posicion de drop de items
func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position

#Drop item
func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)

#Incrementar inventario
func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()

#Agregar elemento al cinturon
func add_hotbar_item(item):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false

#Borrar item del cinturon
func remove_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

#Desligar item del cinturon
func unassign_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

#Prevenir duplicado en cinturon
func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_inventory

#Intercambiar items en el inventario basados en sus indices
func swap_inventory_items(index1, index2):
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true

#Intercambiar items en el cinturon basados en sus indices
func swap_hotbar_items(index1, index2):
	if index1 < 0 or index1 > hotbar_inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	var temp = hotbar_inventory[index1]
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	inventory_updated.emit()
	return true
#Posicion referencia de nodo Player
func set_player_reference(player):
	player_node = player
