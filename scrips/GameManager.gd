extends Node

func reiniciar_todo_excepto_puntaje_y_estrellas():
	print ("reiniciar")
	var root = get_tree().get_root()
	var num_children = root.get_child_count()
	for i in range(num_children):
		var child = root.get_child(i)
		reiniciar_nodo(child)
		

func reiniciar_nodo(node):
	if node != null:
		if not (node.has_method("reiniciar_excepto_puntaje_y_estrellas")):
			reiniciar_nodo_recursivo(node)
		else:
			node.reiniciar_excepto_puntaje_y_estrellas()

func reiniciar_nodo_recursivo(node):
	# Recorre los nodos hijos y reinicia cada uno recursivamente
	var num_children = node.get_child_count()
	for i in range(num_children):
		var child = node.get_child(i)
		reiniciar_nodo(child)
		
