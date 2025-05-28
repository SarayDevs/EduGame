extends Control

var boton_presionado: int = -1  # Índice del botón presionado

var nombre_del_perfil: String = ""
@onready var guardado = preload("res://scrips/Guardado.gd").new()
@onready var continuarboton = $HBoxContainer3/Continuar2
@onready var eliminarboton = $HBoxContainer2/EliminarBoton
@onready var etiquetanombre = $"HBoxContainer/BotónPerfil/EtiquetaNombre"
const perfiles_ruta = "res://Datos/perfiles.json"  
var volver_home = load("res://Escenas de Ui/Home.tscn")
var crear_perfil = load("res://Escenas de Ui/CrearPerfil.tscn")

func _ready():
	cargar_perfil_seleccionado()
	guardado.load_game()  # Sin argumentos, ya que no se espera ninguno.

	
func _on_eliminar_boton_pressed():
	eliminar_perfil(0)
	
	
	
	
func _on_eliminar_boton_2_pressed():
	eliminar_perfil(1)
	
	
	
func _on_eliminar_boton_3_pressed():
	eliminar_perfil(2)

	
func _on_botón_perfil_pressed():
	boton_presionado = 0
	if !hay_perfiles_existentes():
		guardar_indice_boton(0)
		get_tree().change_scene_to_packed(crear_perfil)
	else:
		print("Ya existe un perfil, no se cambiará la escena.")

func _on_volver_home_pressed():
	get_tree().change_scene_to_packed(volver_home)

func cargar_perfil_seleccionado():
	var perfiles = load_perfiles()
	
	if len(perfiles) == 1:
		eliminarboton.disabled = false
		continuarboton.disabled = false
	
	if perfiles.size() > 0:
		for i in range(perfiles.size()):
			var perfil = perfiles[i]
			var boton : TextureButton
			match i:
				0:
					boton = $HBoxContainer/BotónPerfil as TextureButton
				1:
					boton = $HBoxContainer/BotónPerfil2 as TextureButton
				2:
					boton = $HBoxContainer/BotónPerfil3 as TextureButton
			actualizar_botón_con_perfil(boton, perfil)
			
			# Guardar el nombre del perfil seleccionado
			if i == boton_presionado:
				nombre_del_perfil = perfil["nombre"]
	else:
		print("No hay perfiles para cargar.")


func actualizar_botón_con_perfil(boton: TextureButton, perfil: Dictionary):
	if perfil.has("imagen_ruta"):
		var image = Image.new()
		var error = image.load(perfil["imagen_ruta"])
		if error == OK:
			var texture = ImageTexture.create_from_image(image)
			boton.texture_normal = texture
			boton.texture_hover = texture
			boton.texture_pressed = texture
			texture.set_size_override(Vector2(80, 80))
		else:
			print("Error al cargar la imagen: ", perfil["imagen_ruta"])
	else:
		print("Perfil no tiene ruta de imagen.")
	
	var etiqueta : Label
	match boton.name:
		"BotónPerfil":
			etiqueta = etiquetanombre
	if etiqueta and perfil.has("nombre"):
		etiqueta.text = perfil["nombre"]
		nombre_del_perfil = perfil["nombre"]  # Asigna el nombre del perfil aquí
	else:
		print("No se encontró la etiqueta o el perfil no tiene nombre.")

func load_perfiles():
	if FileAccess.file_exists(perfiles_ruta):
		var file = FileAccess.open(perfiles_ruta, FileAccess.READ)
		if file:
			var json = JSON.new()
			var result = json.parse(file.get_as_text())
			file.close()
			if result == OK:
				return json.get_data()
			else:
				print("Error al parsear JSON")
		else:
			print("Error al abrir el archivo JSON")
	else:
		print("El archivo de perfiles no existe.")
	return []

func hay_perfiles_existentes() -> bool:
	var perfiles = load_perfiles()
	return perfiles.size() > 0

func guardar_indice_boton(indice):
	var file = FileAccess.open("user://indice_boton_presionado.dat", FileAccess.WRITE)
	file.store_32(indice)
	file.close()

func guardar_perfiles(perfiles):
	var file = FileAccess.open(perfiles_ruta, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(perfiles)
		file.store_string(json_string)
		file.close()
		cargar_perfil_seleccionado()  # Recargar los perfiles desde el archivo JSON después de guardar
	else:
		print("Error al abrir el archivo para guardar perfiles.")

func eliminar_perfil(indice):
	var perfiles = load_perfiles()
	if indice >= 0 and indice < perfiles.size():
		perfiles.remove_at(indice)
		guardar_perfiles(perfiles)
		print("Perfil eliminado")
		get_tree().reload_current_scene()  # Recargar la escena actual para reflejar los cambios
	else:
		print("Índice fuera de rango")

func _on_continuar_2_pressed():
	if nombre_del_perfil != "":
		cargar_y_continuar(nombre_del_perfil)
	else:
		print("No se ha seleccionado un perfil.")

func cargar_y_continuar(perfil_nombre: String) -> void:
	
	guardado.load_game()
	if guardado.game_data["nivel"] > 1:
		get_tree().change_scene_to_file("res://Escenas/Nivel" + str(guardado.game_data["nivel"]) + ".tscn")
	else:
		get_tree().change_scene_to_file("res://Escenas/animacion_1.tscn")



func set_nombre_del_perfil(perfil: String) -> void:
	nombre_del_perfil = perfil
	print("Nombre del perfil establecido:", nombre_del_perfil)
