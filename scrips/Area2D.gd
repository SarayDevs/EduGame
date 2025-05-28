extends Area2D

func _on_player_max_items():
	call_deferred("_deferred_on_player_max_items")

func _deferred_on_player_max_items():
	$PuertaAbrirSprite2D3/AnimatedSprite2D.play("abrir")
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	if body.name == "player":  # Verifica si el nodo que entró es el jugador
		$"..".Fin()  # Llama a Fin() en el nodo padre de manera diferida
