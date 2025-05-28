extends Node
var save_path = "user://savegame.dat"

func ready():
	load_game() 
	
var game_data: Dictionary = {
	"Time": 1,
	"nivel": 1,
	"Score": 1,
	"Estrellas": 1,
	"User" : "Guizz"
	}
	
func save_game() -> void: 
	var save_file= FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file=null
	
	
func load_game():
	if FileAccess.file_exists(save_path):
		var save_file=FileAccess.open(save_path, FileAccess.READ)
		save_file=null
