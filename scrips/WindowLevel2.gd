extends Node2D
@onready var popup = $"Window2"

# Called when the node enters the scene tree for the first time.
func _ready():
	popup.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_window_close_requested():
	popup.hide()
