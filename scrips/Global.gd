extends Node

var nombre_del_perfil: String = ""

func set_nombre_del_perfil(perfil: String) -> void:
	nombre_del_perfil = perfil
	print("Nombre del perfil global establecido:", nombre_del_perfil)

func get_nombre_del_perfil() -> String:
	return nombre_del_perfil
