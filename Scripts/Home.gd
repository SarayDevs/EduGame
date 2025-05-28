extends Control
@onready var Music = $AudioStreamPlayer
var music_playing = true
var escena_per = load("res://Escenas de Ui/Perfiles.tscn")
var escena_log = load("res://Escenas de Ui/Logros.tscn")
var escena_cred = load("res://Escenas de Ui/Creditos.tscn")
@onready var Conejo = $Conejo/AnimationPlayer
@onready var Capibara = $AnimationPlayer

func _ready():
	
	Music.play()
	Conejo.play("correConejo")
	Capibara.play("new_animation")
	
func _on_perfiles_pressed():
	get_tree().change_scene_to_packed(escena_per)
	print("Botón Perfiles presionado")
	
func _on_logros_pressed():
	get_tree().change_scene_to_packed(escena_log)
	print("Botón Logros presionado")
	
func _on_créditos_pressed():
	get_tree().change_scene_to_packed(escena_cred)
	print("Botón Créditos presionado")
	
func _on_música_pressed():
	if music_playing:
		Music.stop()
		music_playing = false
	else:
		Music.play()
		music_playing = true
	print("Ícono Música presionado, estado de la música:", music_playing)
	
func _on_fx_pressed():
	print("Ícono FX presionado")
