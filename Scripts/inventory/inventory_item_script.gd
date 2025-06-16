@tool
extends Node2D

#Relleno de informacion del item
@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_effect = ""
@export var item_description = ""
var scene_path = "res://Scenes/Inventory/inventory_item.tscn"

#Referencia al Sprite del icono
@onready var icon_sprite = $Sprite2D
#Referencia al interact UI
@onready var interact_ui: CanvasLayer = $Interact_UI
@onready var interact_label: Label = $Interact_UI/InteractLabel

#Cinturon
var belt_size = 4
var inventory_belt = []

#Activacion de cercania del jugador al item
var player_in_range = false

func _ready():
	#verifica si el código se está ejecutando en el editor o en el juego
	#evita que cambios se ejecuten durante la edicion
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(_delta: float):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if player_in_range:
		interact_ui.visible = true
		interact_label.text = str(GlobalItemList.interact_Label["take"])
	else:
		interact_ui.visible = false
	if player_in_range and Input.is_action_just_pressed("ui_add"):
		pickup_item()

func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"effect": item_effect,
		"description": item_description,
		"texture": item_texture,
		"scene_path": scene_path
	}
	if GlobalItemList.player_node:
		GlobalItemList.add_item(item, false)
		self.queue_free()

#setea la data de los items
func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]

#inicia los items para spawnear
func initiate_items(type, new_name, effect, texture, description):
	item_type = type
	item_name = new_name
	item_effect = effect
	item_texture = texture
	item_description = description

func _on_area_2d_body_entered(body):
	if body.is_in_group("character"):
		player_in_range = true
		GlobalItemList.interact_text = str(GlobalItemList.interact_Label["take"])

func _on_area_2d_body_exited(body):
	if body.is_in_group("character"):
		player_in_range = false
