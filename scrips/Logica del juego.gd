extends Node

var music_playing = true
var nombre_del_perfil: String = ""
signal perderEstrella(Cantidad_estrellas)
var volver_home = load("res://Escenas de Ui/Home.tscn")

@onready var musica = $AudioStreamPlayer
var Score: int = 0
var stars: int = 3

func _ready():
	Guardado.load_game()
	print (Guardado.game_data)
	musica.play()
	get_tree().paused = false

# Incrementa el puntaje y maneja la victoria
func subirScore():
	Score += 1
	$Puntos/points.text = str(Score)
	$PantallaGanar/HBoxContainer/FinalScore.text = str(Score)
	$PantallaPerder/HBoxContainer/FinalScore.text = str(Score)

	if Score == 1:  # Ajusta esta condición según sea necesario para ganar el nivel
		$Camera2D/WIN.VICTORIA()
		Guardado.game_data["nivel"] +=1
		Guardado.game_data["Score"] += 10
		Guardado.save_game()
		print (Guardado.game_data)
		$PantallaGanar.show()
		$Puntos.hide()

# Reduce las estrellas y maneja la derrota
func lose_star():
	stars -= 1
	perderEstrella.emit(stars)
	$Puntos/points.text = str(Score)
	$PantallaGanar/HBoxContainer/FinalScore.text = str(Score)
	$PantallaPerder/HBoxContainer/FinalScore.text = str(Score)

	if stars == 0:
		print("Perdiste")
		$Camera2D/gameover.REINICIAR()
		$PantallaPerder.show()
		$Puntos.hide()

func _on_música_pressed():
	if music_playing:
		musica.stop()
		music_playing = false
	else:
		musica.play()
		music_playing = true
	print("Ícono Música presionado, estado de la música:", music_playing)
# Cambio de escena a la pantalla de inicio
func _on_button_2_pressed():
	get_tree().change_scene_to_packed(volver_home)

func _on_inicio_2_pressed():
	get_tree().change_scene_to_packed(volver_home)
	
func _on_inicio_pressed():
	get_tree().change_scene_to_packed(volver_home)
