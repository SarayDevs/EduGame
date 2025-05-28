extends Area2D

# Este script se añade al Area2D especial

# Conectamos la señal de cuerpo entrante para que pueda ser utilizada en el nodo root
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

# Función que se ejecuta cuando un cuerpo entra en el área
func _on_area_entered(area):
	print("Un cuerpo ha entrado en:", self.name)
