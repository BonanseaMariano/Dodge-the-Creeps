extends CanvasLayer
signal reiniciar


func _on_Reiniciar_pressed():
	emit_signal("reiniciar")

