extends Control

@onready var recarga = "res://Escenas/cargar.tscn"
const PERFILES_RUTA = "res://Datos/perfiles.json"
const IMAGENES_RUTA = "res://Datos/img/"
var volver_perfiles = preload("res://Escenas de Ui/Perfiles.tscn")
@onready var nombre_input = $VentanaCrearPerfil/VBoxContainer/IngresarNombre
@onready var guardar_button = $VentanaCrearPerfil/VBoxContainer/GuardarPerfil
@onready var direccion_imagen = $"VentanaCrearPerfil/VBoxContainer/Direccion Imagen"
@onready var icono_1 = $VentanaCrearPerfil/VBoxContainer/HBoxContainer/Icono_1
@onready var icono_2 = $VentanaCrearPerfil/VBoxContainer/HBoxContainer/Icono_2
var perfiles = []
var img_sel = ""
var boton_presionado = -1  # Índice del botón presionado en la escena Perfiles

func _ready():
	reload_resources_in_directory("res://Datos") # Asegúrate de pasar el argumento necesario
	if not FileAccess.file_exists(PERFILES_RUTA):
		var file = FileAccess.open(PERFILES_RUTA, FileAccess.WRITE)
		file.store_string("[]")
		file.close()
	
	guardar_button.disabled = false
	guardar_button.pressed.connect(_on_guardar_button_pressed)

func guardar_imagen(origen: String, destino: String) -> bool:
	var file = FileAccess.open(origen, FileAccess.READ)
	if file:
		var data = file.get_buffer(file.get_length())
		file.close()

		var destino_file = FileAccess.open(destino, FileAccess.WRITE)
		if destino_file:
			destino_file.store_buffer(data)
			destino_file.close()
			print("Imagen guardada en: ", destino)
			return true
		else:
			print("No se pudo guardar la imagen en: ", destino)
			return false
	else:
		print("No se pudo abrir la imagen desde: ", origen)
		return false

func _on_guardar_button_pressed():
	# Cargar perfil anterior, sino se sobreescribe la lista perfiles 
	load_perfiles()
	reload_resources_in_directory("res://Datos") # Asegúrate de pasar el argumento necesario
	var nombre = nombre_input.text
	var perfil = {
		"nombre": nombre,
		"imagen_ruta": "Datos/img/" + direccion_imagen.text  # Ruta relativa dentro del proyecto
	}
	perfiles.append(perfil)
	guardar_perfiles()
	nombre_input.text = ""
	call_deferred("cambiar_perfiles_scene")

func guardar_perfiles():
	var file = FileAccess.open(PERFILES_RUTA, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(perfiles) # Convertir datos a cadena JSON
		file.store_string(json_string) # Almacenar la cadena JSON en el archivo
		file.close()
	else:
		print("Error al abrir el archivo para guardar perfiles.")

func load_perfiles():
	if FileAccess.file_exists(PERFILES_RUTA):
		var file = FileAccess.open(PERFILES_RUTA, FileAccess.READ)
		if file:
			var json = JSON.new() # Crear instancia de JSON
			var result = json.parse(file.get_as_text()) # Parsear el JSON
			if result == OK:
				perfiles = json.get_data() # Obtener los datos del JSON
			else:
				print("Error al parsear JSON")
			file.close()
		else:
			print("Error al abrir el archivo para cargar perfiles.")
	else:
		print("El archivo de perfiles no existe.")

func guardar_indice_boton(indice):
	# Guarda el índice del botón presionado en un archivo temporal o en una variable global
	var file = FileAccess.open("user://indice_boton_presionado.dat", FileAccess.WRITE)
	file.store_32(indice)
	file.close()

func cambiar_perfiles_scene():
	get_tree().change_scene_to_packed(volver_perfiles)

func _on_icono_1_pressed():
	direccion_imagen.text = "frontcapibara.png"

func _on_icono_2_pressed():
	direccion_imagen.text = "frontgata.png"

func reload_resources_in_directory(directory_path: String):
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if dir.current_is_dir():
				# Si es un directorio, llama recursivamente para revisar dentro.
				reload_resources_in_directory(directory_path + "/" + file_name)
			else:
				var full_path = directory_path + "/" + file_name
				ResourceLoader.load(full_path) # Recargar el recurso especificando CacheMode
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("No se pudo abrir el directorio: ", directory_path)
