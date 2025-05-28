extends Node2D
var music_playing = true
@onready var GlobalScript = preload("res://scrips/Global.gd").new()
var nombre_del_perfil: String = ""
signal perderCorazon(Cantidad_corazones)

var tiempo_restante = 40
var tiempo : int = 0
var corazon : int = 3
@onready var Music = $AudioStreamPlayer

func _ready():
	Guardado.load_game()
	print (Guardado.game_data)

	get_tree().paused = false
	if GlobalScript:
		nombre_del_perfil = GlobalScript.get_nombre_del_perfil()
		print("Nombre del perfil global en Mundo:", nombre_del_perfil)
	else:
		print("Error: GlobalScript no está disponible.")
	
	$Camera2D/gameover._ready()
	$Timer.start()
	Music.play()
	# Asegúrate de que se obtenga el nombre del perfil desde el script global
func _on_música_pressed():
	if music_playing:
		Music.stop()
		music_playing = false
	else:
		Music.play()
		music_playing = true
	print("Ícono Música presionado, estado de la música:", music_playing)
	
func CorrerTiempo():
	tiempo_restante += 10
	$Camera2D/CanvasLayer/points.text = str(tiempo_restante)

func Fin():
	$Camera2D/WIN.VICTORIA()
	Guardado.game_data["Time"] += tiempo_restante
	Guardado.save_game()
	$PantallaMuerte.show()

func lose_corazon():
	corazon -= 1
	perderCorazon.emit(corazon)
	
	if corazon == 0:
		print("Perdiste")
		$Camera2D/gameover.REINICIAR()
		$PantallaMuerte2.show()

func _on_timer_timeout():
	tiempo_restante -= 1
	$Camera2D/CanvasLayer/points.text = str(tiempo_restante)
	if tiempo_restante <= 0:
		$Timer.stop()
		print("El tiempo se ha agotado!")
		$Camera2D/gameover.REINICIAR()
		$PantallaMuerte2.show()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Fin()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		Fin()
