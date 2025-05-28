extends Node2D

var coleccionable = preload("res://Escenas/objetosCaen.tscn")


func _ready():
	$Timer.stop()
	$Timer.wait_time=randf_range(2,16)
	$Timer.start()

func _on_timer_timeout():
	var colec = coleccionable.instantiate()
	#colec.global_position = global_position
	add_child(colec)
