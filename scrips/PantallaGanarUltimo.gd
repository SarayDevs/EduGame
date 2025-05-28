extends CanvasLayer

const  EstrellaVacia = preload ("res://Asset/Special Icons (3).png")
const  EstrellaLlena = preload ("res://Asset/Special Icons (2).png")

@onready var estrella1 = $HBoxContainer2/estrella1
@onready var estrella2 = $HBoxContainer2/estrella2
@onready var estrella3 = $HBoxContainer2/estrella3

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_left_pressed():
	get_tree().change_scene_to_file("res://Escenas/animacion_2.tscn")

func _on_nivel_3_perder_estrella(Cantidad_estrellas):
	$HBoxContainer2/estrella1.texture = EstrellaLlena if Cantidad_estrellas >=3 else EstrellaVacia 
	$HBoxContainer2/estrella2.texture = EstrellaLlena if Cantidad_estrellas >=2 else EstrellaVacia 
	$HBoxContainer2/estrella3.texture = EstrellaLlena if Cantidad_estrellas >=1 else EstrellaVacia
