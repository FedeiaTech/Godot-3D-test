class_name StateMachine extends Node
#Esta clase se encargara de controlara los estado globales como el
#estadoo activo o ejecutar los metodos que correspondan

#nodo que vamos a controlar
@onready var controlled_node = self.owner

#estado por defecto. cuando se ejecute por primera vez
@export var default_state: StateBase

#estado en ejecucion en cada momento
var current_state : StateBase = null

func _ready() -> void:
	#de esta forma nos aseguramos que todos los nodos de la maquina estan listos
	call_deferred("_state_default_start")

func _state_default_start() -> void:
	current_state = default_state
	_state_start()

# Funcion que prepara las variables para el nuevo estado y lanza su start
func _state_start() -> void:
	#prints("StateMachine", controlled_node.name, "start state", current_state.name)
	#Configuramos el estado
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

# funcion para cambiar de un estado a un nuevo estado
func change_to(new_state:String) -> void:
	if current_state and current_state.has_method("end"): current_state.end()
	current_state = get_node(new_state)
	_state_start()

## Region metodos que se ejecutan solos

func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)

func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)
	#abrir inventario
	if event.is_action_pressed("ui_inventory"):
		GlobalItemList.inventory_visible = !GlobalItemList.inventory_visible

func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_key_input(event)

## Endregion
