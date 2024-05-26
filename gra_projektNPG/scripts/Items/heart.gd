extends Node2D

var collected = false

func _process(delta):
	if collected:
		#Changing transparency
		modulate.a = lerp(modulate.a, 0.0, 2.0 * delta)


func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		collected = true
		GameManager.gain_health(1)
		await get_tree().create_timer(0.5).timeout
		hide()
		queue_free()