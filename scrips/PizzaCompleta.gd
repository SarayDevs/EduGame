extends Area2D

var posicion_inicial3: Vector2
var cortes_realizados = 0
var porciones = 0

# Exportar las escenas de las porciones de pizza
@export var porcion1_scene: PackedScene
@export var porcion2_scene: PackedScene
@export var porcion3_scene: PackedScene
@export var porcion4_scene: PackedScene
@export var porcion5_scene: PackedScene
@export var porcion6_scene: PackedScene
@export var porcion7_scene: PackedScene
@export var porcion8_scene: PackedScene
@export var porcion9_scene: PackedScene
@export var porcion10_scene: PackedScene
@export var porcion11_scene: PackedScene
@export var porcion12_scene: PackedScene
@export var porcion13_scene: PackedScene
@export var porcion14_scene: PackedScene
@export var porcion15_scene: PackedScene
@export var porcion16_scene: PackedScene

@onready var cortador = $"../cortador"

var cortador_en_contacto1 = false
var porciones_instanciadas: Array = []

func _ready():
	posicion_inicial3 = position

func _on_area_entered(area):
	if area.name == "cortador" and !cortador_en_contacto1:
		cortador_en_contacto1 = true
		if cortador.cortes == 2:
			cortes_realizados =1
		elif cortador.cortes ==4:
			cortes_realizados =2
		elif cortador.cortes==6:
			cortes_realizados =3
		elif cortador.cortes == 8:
			cortes_realizados = 4
		else:
			print("Ya no hay mas")
		$"../CORTES".reiniciar_cortador_en_contacto()

func dividir_pizza():
	print("Divide")
	match porciones:
		0:
			hide()
		1:
			add_porciones1()
			hide()
		2:
			add_porciones2()
			hide()
		3:
			add_porciones3()
			hide()
		4:
			add_porciones4()
			hide()

func add_porciones1():
	var porcion1 = porcion1_scene.instantiate()
	var porcion2 = porcion2_scene.instantiate()
	call_deferred("add_porciones", [porcion1, porcion2])

func add_porciones2():
	var porcion3 = porcion3_scene.instantiate()
	var porcion4 = porcion4_scene.instantiate()
	var porcion5 = porcion5_scene.instantiate()
	var porcion6 = porcion6_scene.instantiate()
	call_deferred("add_porciones", [porcion3, porcion4, porcion5, porcion6])

func add_porciones3():
	var porcion7 = porcion7_scene.instantiate()
	var porcion8 = porcion8_scene.instantiate()
	var porcion9 = porcion9_scene.instantiate()
	var porcion10 = porcion10_scene.instantiate()
	var porcion11 = porcion11_scene.instantiate()
	var porcion12 = porcion12_scene.instantiate()
	call_deferred("add_porciones", [porcion7, porcion8, porcion9, porcion10, porcion11, porcion12] )

func add_porciones4():
	var porcion13 = porcion13_scene.instantiate()
	var porcion9 = porcion9_scene.instantiate()
	var porcion8 = porcion8_scene.instantiate()
	var porcion14 = porcion14_scene.instantiate()
	var porcion10 = porcion10_scene.instantiate()
	var porcion11 = porcion11_scene.instantiate()
	var porcion15 = porcion15_scene.instantiate()
	var porcion16 = porcion16_scene.instantiate()
	
	call_deferred("add_porciones", [porcion13,porcion9, porcion8, porcion14, porcion10, porcion11, porcion15, porcion16])

func add_porciones(nuevas_porciones):
	# Verificar si las porciones instanciadas aún existen antes de intentar liberarlas
	for porcion in porciones_instanciadas:
		if porcion and porcion.is_inside_tree():
			porcion.queue_free()
		elif porcion:
			# Si la porción ya no está en el árbol, no hacer nada
			print("Porción ya fue eliminada:", porcion)

	porciones_instanciadas.clear()

	# Añadir las nuevas porciones
	for porcion in nuevas_porciones:
		get_parent().call_deferred("add_child", porcion)
		porciones_instanciadas.append(porcion)

	# Verificación diferida para asegurar que todas las porciones se añadieron correctamente
	call_deferred("_verificar_porciones", nuevas_porciones)

func _verificar_porciones(nuevas_porciones):
	var faltan_porciones = false
	for porcion in nuevas_porciones:
		if not porcion.is_inside_tree():
			faltan_porciones = true
			break
	
	if faltan_porciones:
		print("No todas las porciones se añadieron correctamente. Reintentando...")
		for porcion in nuevas_porciones:
			if not porcion.is_inside_tree():
				get_parent().call_deferred("add_child", porcion)
	
	print("Verificación completa. Porciones actuales:", porciones_instanciadas)



func _on_plato_pizzacompleta():
	print("PizzaCompleta  reinicio por timbre")

func _on_cortes_corte_realizado():
	print("Corte realizado")
	porciones += 1
	dividir_pizza()

func _on_timbre_2d_evaluar_timbre():
	$"../GameManager".reiniciar_todo_excepto_puntaje_y_estrellas()
	reiniciar_pizza()

func reiniciar_pizza():
	cortes_realizados = 0
	porciones = 0
	position = posicion_inicial3
	show()
	reiniciar_arrays()
	$"../CORTES".reiniciar_cortador_en_contacto()

func reiniciar_arrays():
	for porcion in porciones_instanciadas:
		if porcion:
			porcion.queue_free()
	porciones_instanciadas.clear()
	print("Mira lo que hay:", porciones_instanciadas)

func cantidadcortes():
	if add_porciones1():
		cortador.cortes=2
	elif add_porciones2():
		cortador.cortes=4
	elif add_porciones3():
		cortador.cortes=6
	elif add_porciones4():
		cortador.cortes=8
