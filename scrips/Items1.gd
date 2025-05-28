extends Area2D

var es_ingrediente = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		if es_ingrediente:
			body.subirScore()
		else:
			body.morirse()
		queue_free()
	
