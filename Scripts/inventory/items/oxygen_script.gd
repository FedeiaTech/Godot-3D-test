extends "res://Scripts/inventory/belt/slot_belt_script.gd"

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var item_id = 0
var is_collected : bool = false

func _ready() -> void:
	item_texture = preload("res://Assets/Img/Utilities/oxygen2.png")
	print(item_texture)
	
func use():
	Global.oxygen += 50
	queue_free()
	#quitar un elemento del inventario

func collect():
	is_collected = true
	var cloned_item = self.duplicate() #Clona el item
	cloned_item.item_texture = self.item_texture
	Global.add_item_to_belt(cloned_item)
	var inventory_node = $"../../../Player/Jugador/Inventory"
	#if inventory_node:
		#inventory_node.update_inventory_UI()
	#else:
		#print("Fallo en cargar inventario")
	$"Got_audio".play()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		#collect()
		pass

func _on_mouse_entered() -> void:
	sprite_2d.material =  load("res://FXs/Material_select.tres")

func _on_mouse_exited() -> void:
	sprite_2d.material =  null
