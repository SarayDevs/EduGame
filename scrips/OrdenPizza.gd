extends CanvasLayer

func _ready():
	# Configurar la visualización inicial si es necesario
	pass
func mostrarOrden(porcentajes, ingredientes):
	limpiarHBox($HBoxPorcentajes)
	limpiarHBox($HBoxIngredientes)
	
	# Mostrar porcentajes en pantalla
	for i in range(porcentajes.size()):
		var porcentaje = porcentajes[i]
		var ingrediente = ingredientes[i]
		
		# Mostrar porcentaje en pantalla
		var labelPorcentaje = Label.new()
		labelPorcentaje.text = str(porcentaje) + "%"
		labelPorcentaje.set_custom_minimum_size(Vector2(50, 50))  # Ajustar tamaño mínimo
		
		# Ajustar tamaño de la fuente
		#var font = DynamicFont.new()
		#font.font_path = "res://ruta_a_tu_fuente.ttf"  # Asegúrate de tener una fuente en tu proyecto
		#font.size = 24  # Ajustar tamaño de la fuente
		#labelPorcentaje.add_font_override("font", font)
		
		$HBoxPorcentajes.add_child(labelPorcentaje)
		
		# Mostrar textura de ingrediente en pantalla
		var textureRectIngrediente = TextureRect.new()
		textureRectIngrediente.texture = load("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes/" + ingrediente + ".png")
		textureRectIngrediente.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Ajustar modo de estirado
		textureRectIngrediente.set_custom_minimum_size(Vector2(20, 20))  # Ajustar tamaño mínimo
		$HBoxIngredientes.add_child(textureRectIngrediente)

func limpiarHBox(hbox):
	# Remover todos los hijos del HBoxContainer
	while hbox.get_child_count() > 0:
		hbox.remove_child(hbox.get_child(0))
