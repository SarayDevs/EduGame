extends Button

@onready var control_node = $"../videos1"

func _ready():
	pass
func _on_pressed():
	get_tree().change_scene_to_file("res://Escenas/videos1.tscn")
