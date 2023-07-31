extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names() #Arreglo de animaciones que devuelve todas las animaciones posibles
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()] #Selecciona una de esas animaciones del array al azar (randi() %)

func _on_VisibilityNotifier2D_screen_exited(): #El enemigo abandona la pantalla
	queue_free()
