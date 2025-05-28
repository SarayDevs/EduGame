extends CanvasLayer

@onready var music = $Musica
@onready var fx = $Sonido
@onready var anim = $AnimationPlayer
@onready var anim1 = $Sprite2D/AnimationPlayer1

func _ready():
	#layer es para poner el canvaslayer detras del juego
	$".".hide()
	
func VICTORIA() -> void:
	#layer es para poner el canvaslayer delante del juego
	music.play()
	fx.play()
	$Sprite2D.show()
	$".".show()
	
	get_tree().paused = true
	#Reproducir la animacion: trans
	anim.play("game")
	anim1.play("Ganar")
	await ($AnimationPlayer.animation_finished)
