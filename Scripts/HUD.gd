extends CanvasLayer

signal start_game #esta señal indica que se apreto el boton de inicio al main


func show_message(text): #Esta funcion es para mostrar el texto temporal de inicio o al morir
	$Message.show()
	$MessageTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	Gamehandler.cargar_partida()
	update_highscore()


func show_game_over(): #Esta función se llamará cuando el jugador pierde. Mostrará "Game Over" durante 2 segundos, luego volverá a la pantalla de título y revelará el botón "Start".
	show_message("Juego Terminado")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()	

func update_score(score): #Funcion para actualizar el score
	$ScoreLabel.text = str(score)

func update_highscore():
	if (Gamehandler.score > Gamehandler.highscore):
		Gamehandler.highscore = Gamehandler.score
		Gamehandler.guardar_partida()
	$Puntaje.text = str(Gamehandler.highscore)
		

func _on_MessageTimer_timeout(): #Esconde el texto para que inicie el juego
	$Message.hide()


func _on_StartButton_pressed(): #al apretar el boton de iniciar juego
	$StartButton.hide()
	emit_signal("start_game")
