extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var anim1 = $Sprite2D/AnimationPlayer
@onready var fx = $Sonido
@onready var music = $Musica


func _ready():
	#layer es para poner el canvaslayer detras del juego
	$".".hide()

	
	
func REINICIAR() -> void:
	$".".show()
	$Text.show()
	$Text2.show()
	$Sprite2D.show()
	fx.play()
	music.play()
	
	get_tree().paused = true
	#Reproducir la animacion: trans
	anim.play("game")
	anim1.play("DIE")
	await ($AnimationPlayer.animation_finished)
	
