extends CanvasLayer

signal use_move_vector
var move_vector = Vector2.ZERO
var joystik_active = false

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $Joystik.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystik_active = true
			$circulito.position = event.position
			$circulito.visible = true
		
		if event is InputEventScreenTouch:
			if event.pressed == false:
				joystik_active = false
				$circulito.visible = false

func _physics_process(delta):
	if joystik_active:
		emit_signal("use_move_vector", move_vector)
	elif joystik_active == false:
		emit_signal("use_move_vector", Vector2.ZERO)


func calculate_move_vector(event_position):
	var texture_center = $Joystik.position + Vector2(150,150)
	return (event_position - texture_center).normalized()
