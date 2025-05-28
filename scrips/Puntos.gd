extends CanvasLayer

const  EstrellaVacia = preload ("res://Asset/Special Icons (3).png")
const  EstrellaLlena = preload ("res://Asset/Special Icons (2).png")


func _on_nivel_1_perder_estrella(Cantidad_estrellas):
	$HBoxContainer/estrella1.texture = EstrellaLlena if Cantidad_estrellas >=3 else EstrellaVacia 
	$HBoxContainer/estrella2.texture = EstrellaLlena if Cantidad_estrellas >=2 else EstrellaVacia 
	$HBoxContainer/estrella3.texture = EstrellaLlena if Cantidad_estrellas >=1 else EstrellaVacia 


func _on_nivel_2_perder_estrella(Cantidad_estrellas):
	$HBoxContainer/estrella1.texture = EstrellaLlena if Cantidad_estrellas >=3 else EstrellaVacia 
	$HBoxContainer/estrella2.texture = EstrellaLlena if Cantidad_estrellas >=2 else EstrellaVacia 
	$HBoxContainer/estrella3.texture = EstrellaLlena if Cantidad_estrellas >=1 else EstrellaVacia 


func _on_nivel_3_perder_estrella(Cantidad_estrellas):
	$HBoxContainer/estrella1.texture = EstrellaLlena if Cantidad_estrellas >=3 else EstrellaVacia 
	$HBoxContainer/estrella2.texture = EstrellaLlena if Cantidad_estrellas >=2 else EstrellaVacia 
	$HBoxContainer/estrella3.texture = EstrellaLlena if Cantidad_estrellas >=1 else EstrellaVacia 
