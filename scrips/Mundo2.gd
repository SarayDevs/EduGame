extends Node2D
var music_playing = true
var nombre_del_perfil: String = ""
@onready var player = $player
var ScoreJugador := 0
@onready var musica = $musica
@onready var explosion = $explosion
@onready var recolectar = $recolectar

signal dificultad_cambiada(new_dificultad)

var dificultad = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Guardado.load_game()
	get_tree().paused = false
	player.connect("ScoreUP", subirScore)
	player.connect("PlayerDied", morir)
	musica.play()
	# Emitir la señal cada vez que se actualice la dificultad

func _process(delta):
	# Ejemplo de cómo podrías incrementar la dificultad
	dificultad += 0.1 * delta
	emit_signal("dificultad_cambiada", dificultad)

func subirScore():
	ScoreJugador += 1
	$Label.text = str(ScoreJugador)
	recolectar.play()
	if ScoreJugador == 100:
		$Camera2D/WIN.VICTORIA()
		Guardado.game_data["Score"] += 200
		Guardado.game_data["nivel"] += 1
		Guardado.save_game()
		$PantallaMuerte.show()
		$PantallaMuerte/HBoxContainer/FinalScore.text = str(ScoreJugador)
	
func morir():
	explosion.play()
	await get_tree().create_timer(1.0).timeout
	$PantallaMuerte2/HBoxContainer/FinalScore.text = str(ScoreJugador)
	$Camera2D/gameover.REINICIAR()
	$PantallaMuerte2.show()

func _on_música_pressed():
	if music_playing:
		musica.stop()
		music_playing = false
	else:
		musica.play()
		music_playing = true
	print("Ícono Música presionado, estado de la música:", music_playing)
	
func _on_player_player_died():
	explosion.play()
	await get_tree().create_timer(1.0).timeout
	$PantallaMuerte2/HBoxContainer/FinalScore.text = str(ScoreJugador)
	$Camera2D/gameover.REINICIAR()
	$PantallaMuerte2.show()
