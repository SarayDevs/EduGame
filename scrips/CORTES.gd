extends Area2D
signal corte_realizado()
var cortador_en_contacto = false


func _on_area_entered(area):
	
	if area.is_in_group("cortador") and !cortador_en_contacto:
		print ("Quizas")
		emit_signal("corte_realizado")
		
		
func reiniciar_cortador_en_contacto():
	cortador_en_contacto = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timbre_2d_evaluar_timbre():
	reiniciar_cortador_en_contacto()
