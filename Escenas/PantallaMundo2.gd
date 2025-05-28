extends CanvasLayer


	
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_left_pressed():
	get_tree().change_scene_to_file("res://Escenas/videos3.tscn")
