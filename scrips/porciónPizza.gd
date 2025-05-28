extends Area2D

var initial_position2: Vector2
var mouseIn = false

var fraccion = null

var dragging = false
var selected_object = null

@onready var agarrar = $"../Agarrar"
@onready var soltar = $"../Soltar"
func _ready():
	initial_position2 = position
	
func _process(_delta):
	if Clock.is_dragging and Clock.selected_sprite == self:
		position = get_viewport().get_mouse_position()
		


func _on_mouse_entered():
	mouseIn = true 
	pass # Replace with function body.

func _on_mouse_exited():
	mouseIn = false

func reset_position():
	set_position(initial_position2)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and mouseIn:
			
			if Clock.selected_sprite == self:
				soltar.play()
				# Si este sprite ya está siendo arrastrado, soltarlo
				Clock.is_dragging = false
				Clock.selected_sprite = null
			elif Clock.selected_sprite == null:
				agarrar.play()
				# Si no hay ningún sprite siendo arrastrado, empezar a arrastrar este sprite
				Clock.is_dragging = true
				Clock.selected_sprite = self
