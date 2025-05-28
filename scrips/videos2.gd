extends Control

@onready var Music = $AudioStreamPlayer
@onready var video_stream_player = $VideoStreamPlayer
@onready var skip_button = $Button  # Asegúrate de tener un botón en tu escena con el nombre "SkipButton"

func _ready():
	get_tree().paused = false
	Music.play()
	# Reproduce el video cuando la escena se carga
	video_stream_player.play()
	# Mostrar el botón "Skip" y el mensaje en pantalla
	skip_button.show()
	show_skip_message()

# Función que se llama cuando el video termina
func _on_video_stream_player_finished():
	#var level_1_scene = preload("res://Escenas/Nivel1.tscn")
	get_tree().change_scene_to_file("res://Escenas/Nivel2.tscn")

# Función para detectar la tecla para omitir
func _input(event):
	if event.is_action_pressed("Skip"):  # Asegúrate de configurar "ui_skip" en el Input Map
		skip_video()

# Función para omitir el video
func skip_video():
	video_stream_player.stop()
	_on_video_stream_player_finished()

# Función para mostrar el mensaje en pantalla
func show_skip_message():
	var label = Label.new()
	label.text = "Press 'S' to Skip or use the Skip button"
	label.set_position(Vector2(10, 10))  # Posicionar en la esquina superior izquierda
	add_child(label)

# Función que se llama cuando se presiona el botón "Skip"

func _on_button_pressed():
	skip_video()
