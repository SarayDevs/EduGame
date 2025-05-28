extends Area2D

var mousein = false
var initial_position: Vector2
var dragging = false
@onready var agarrar = $"../Agarrar"
@onready var soltar = $"../Soltar"

func _ready():
	initial_position = position
	set_process_input(true)

func _process(delta):
	if dragging:
		position = get_viewport().get_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if mousein:
					if !dragging:
						agarrar.play()
						dragging = true
						Clock.is_dragging = true
						Clock.selected_sprite = self
			else:
				if dragging:
					soltar.play()
					dragging = false
					Clock.is_dragging = false
					Clock.selected_sprite = null
					
					# Verificar si el ingrediente se ha soltado dentro del área de division2
					if is_inside_division2(position):
						# Desactivar la capacidad de mover el ingrediente
						set_process_input(false)
					else:
						# Resetear la posición si no está dentro del área
						reset_position()
					
func _on_mouse_entered():
	mousein = true

func _on_mouse_exited():
	mousein = false
	
func reset_position():
	position = initial_position

# Función para verificar si la posición está dentro del área de division2
func is_inside_division2(position: Vector2) -> bool:
	var division2 = get_node("../division2")
	if division2:
		var distance = position.distance_to(division2.position)
		return distance <= 160  # Comparar con el radio de 160
	return false
