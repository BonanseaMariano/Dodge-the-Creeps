extends Node

var score = 0
var highscore
var HS = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = Directory.new()
	if(!path.dir_exists("user://DodgeTheCreeps_saves")):
		path.open("user://")
		path.make_dir("user://DodgeTheCreeps_saves")

func guardar_partida():
	var save = File.new()
	save.open("user://DodgeTheCreeps_saves/DTCsave.sav", File.WRITE)
	
	save.store_line(to_json(highscore))
	save.close()
	
func cargar_partida():
	var cargar = File.new()
	if(!cargar.file_exists("user://DodgeTheCreeps_saves/DTCsave.sav")):
		print("No hay partidas guardadas")
		highscore = 0
		return
		
	cargar.open("user://DodgeTheCreeps_saves/DTCsave.sav", File.READ)
	
	if(!cargar.eof_reached()):
		var dat_provis = parse_json(cargar.get_line())
		if(dat_provis != null):
			highscore = dat_provis
	cargar.close()
	
	#Aca desp de cargar el highscore en el main tengo que actulizar los datos
	#En la funcion de cargar partida o en el main hay que ponerle que si no hay partida guardada highscore es 0
