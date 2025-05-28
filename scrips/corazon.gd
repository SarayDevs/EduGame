extends CanvasLayer

const  Corazonlleno = preload ("res://Asset/Special Icons (4).png")
const  CorazonVacio = preload ("res://Asset/Special Icons (5).png")




func _on_mundo_perder_corazon(Cantidad_corazones):
	$HBoxContainer/corazon1.texture = Corazonlleno if Cantidad_corazones >=3 else CorazonVacio
	$HBoxContainer/corazon2.texture = Corazonlleno if Cantidad_corazones >=2 else CorazonVacio
	$HBoxContainer/corazon3.texture = Corazonlleno if Cantidad_corazones >=1 else CorazonVacio

