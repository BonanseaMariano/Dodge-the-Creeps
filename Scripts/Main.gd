extends Node2D

export(PackedScene) var mob_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Mobile.hide()
	$MenuPausa.hide() # Escondo la pantalla de pausa
	Gamehandler.cargar_partida()

func _input(event): # Pausar el juego
	if (!$HUD/Message.visible):
		if event.is_action_pressed("pausa"): 
			$Mobile.visible = !$Mobile.visible
			var music_position = $Music.get_playback_position()
			get_tree().paused = !get_tree().paused
			$Player.speed = 0
			$MobTimer.paused = !$MobTimer.paused
			$ScoreTimer.paused = !$ScoreTimer.paused
			$MenuPausa.visible = !$MenuPausa.visible
			$Music.stop()
			
			if (!get_tree().paused):
				$Player.speed = 400
				$Music.play(music_position)
		
func game_over():
	$Mobile.hide()
	$DeathSound.play()
	$Music.stop()
	$HUD.update_highscore()
	$ScoreTimer.stop() # Finaliza el incremento del score
	$MobTimer.stop() # Finaliza el spawn de mobs
	$HUD.show_game_over() # Mensaje de juego terminado

func new_game(): # Inicia un nuevo juego
	$DeathSound.stop()
	$MobTimer.wait_time = 3.5
	$Player.speed = 400
	get_tree().call_group("mobs", "queue_free") # Reinicia a los mobs que esten dando vueltas
	Gamehandler.score = 0 # Reinicia el score
	$Player.start($StartPosition.position) # Reinicia la posicion del jugador
	$StartTimer.start() # Inicia el timer de inicio
	$HUD.update_score(Gamehandler.score) # Reinicia el texto del score
	$HUD.show_message("Preparate!")
	$Music.play()


func _on_MobTimer_timeout():
	# Crea una instancia del objeto mob.
	var mob = mob_scene.instance()

	# Elige una localizacion random en el Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Hace que la direccion del mob sea perpendicular a el Path2D.
	var direction = mob_spawn_location.rotation + PI / 2

	# Posiciona al mob en una localizacion random.
	mob.position = mob_spawn_location.position

	# Añade un poco de azar a la direccion del mob.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Elige una velocidad random para el mob (incremento de dificultad en base al score).
	var velocity = Vector2(rand_range(Gamehandler.score*2+150, Gamehandler.score*2+250), 0.0)
	
	mob.linear_velocity = velocity.rotated(direction)

	# Spawnea al mob añadiendolo a la escena principal.
	add_child(mob)
	


func _on_StartTimer_timeout(): # Timer de inicio despues de una breve pausa e inicia a los demas
	$Mobile.visible = true
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	Gamehandler.score += 1 # Acumulador de score que se va incrementando a medida pasa el tiempo
	$HUD.update_score(Gamehandler.score) #Actualiza el mensaje del score para ir viendo el puntaje actualizado


func _reiniciar(): #Para reiniciar como es desde el menu de pausa hay que resumir lo demas
	get_tree().paused = !get_tree().paused
	$MobTimer.paused = !$MobTimer.paused
	$ScoreTimer.paused = !$ScoreTimer.paused
	$MenuPausa.visible = !$MenuPausa.visible
	# Esto es como el game over pero como queria que fuera distinto lo stopeo aca
	$Music.stop()
	$ScoreTimer.stop() 
	$MobTimer.stop()
	new_game()

func _process(delta):
	if (Gamehandler.score == 10):
		$MobTimer.wait_time = 3
	if (Gamehandler.score == 20):
		$MobTimer.wait_time = 2
	if (Gamehandler.score == 30):
		$MobTimer.wait_time = 1
	if (Gamehandler.score == 40):
		$MobTimer.wait_time = 0.5

