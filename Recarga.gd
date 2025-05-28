extends Node

# Método para recargar todos los recursos en un directorio específico.
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
				ResourceLoader.load(full_path) # Recargar el recurso sin especificar CacheMode
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("No se pudo abrir el directorio: ", directory_path)

# Llama a este método para recargar recursos en el directorio "res://Datos"
func _ready():
	reload_resources_in_directory("res://Datos")

