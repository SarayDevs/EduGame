extends Area2D

# Variables # El numerador de la fracción objetivo, en este caso 1
var porciones_en_plato: Array = []
var posicion_inicial: Vector2
signal pizzacompleta()
signal reiniciarfracciones()
const CANVAS_LAYER_PATH := "$/root/Nivel1/Fraccion"

@onready var pizza_completa = $"../PizzaCompleta"
@onready var cortador=$"../cortador"


func _ready():
	posicion_inicial = position
	
	
func _on_area_entered(area):
	if area.is_in_group("porciones"):
		_on_PorcionPizza_soltada(area)
		

	
func comprobar_fraccion():
	var cantidad_porciones: int = porciones_en_plato.size()
	
	if cantidad_porciones == cortador.fraccion_numerador and cortador.cortes == cortador.denominador_fraccion:
		print(cortador.fraccion_numerador)
		$"..".subirScore()
	else:
		$"..".lose_star()
	
	# Limpiar el plato después de la comprobación
	await get_tree().create_timer(1.0).timeout


func reiniciar_plato():
	for porcion in get_tree().get_nodes_in_group("porciones"):
		porcion.queue_free()
	porciones_en_plato.clear()
	
	
	emit_signal("pizzacompleta")
	
	
func _on_PorcionPizza_soltada(porcion):
	if porcion not in porciones_en_plato:
		porciones_en_plato.append(porcion)



func _on_timbre_2d_evaluar_timbre():
	comprobar_fraccion()
	reiniciar_plato()
	reiniciar_canvas_layer()


func reiniciar_canvas_layer():
	var canvas_layer = get_node("/root/Nivel1/Fraccion")
	if canvas_layer:
		$"../cortador"._on_plato_reiniciarfracciones()
		# Restablecer el estado del numerador y el denominador
		
		
	else:
		print("Error: No se pudo encontrar el nodo CanvasLayer")


func _on_cortes_corte_realizado():
	print("Una y otra vez")
	
	
	

func _on_cortador_cortar_excedido():
	print ("cortaste de mas")
	$"..".lose_star()
	$"../PizzaCompleta".reiniciar_pizza()
