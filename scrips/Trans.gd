extends CanvasLayer

@onready var anim = $AnimationPlayer

func _ready():
	#layer es para poner el canvaslayer detras del juego
	layer = -1
	$AnimationPlayer.play("trans")
	
func change_scene(path : String) -> void:
	#layer es para poner el canvaslayer delante del juego
	layer = 1
	#Reproducir la animacion: trans
	anim.play("trans")
	await ($AnimationPlayer. animation_finished)
	#cambiar la escena
	get_tree().change_scene_to_file(path)
	anim.play_backwards("trans")
	await ($AnimationPlayer. animation_finished)
	layer = -1

