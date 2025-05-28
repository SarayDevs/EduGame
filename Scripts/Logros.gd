extends Control
@onready var Music = $AudioStreamPlayer
var volver_home = load("res://Escenas de Ui/Home.tscn")
func _ready():
	Music.play()
func _on_volver_pressed():
	get_tree().change_scene_to_packed(volver_home)
	print("Ícono volver presionado")
	
