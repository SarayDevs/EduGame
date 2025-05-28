extends Area2D

@onready var sonido = $"../Timbre"
var mouseCLICK = false

signal evaluarTIMBRE()
# Called when the node enters the scene tree for the first time.

func _input(event):
	if mouseCLICK and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("TILIN TILIN")
		sonido.play() 
		emit_signal("evaluarTIMBRE")
		

func _on_mouse_entered():
	mouseCLICK = true

func _on_mouse_exited():
	mouseCLICK = false
