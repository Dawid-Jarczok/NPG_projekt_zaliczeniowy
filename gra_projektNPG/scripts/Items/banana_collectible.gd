extends Node2D

var collected = false


func _process(delta):
	if collected:
		#Changing transparency
		$AnimatedSprite2D.play("collected")
		await get_tree().create_timer(0.25).timeout
		queue_free()

func _on_banana_body_entered(body):
	if body.is_in_group("Player"):
		collected = true
		GameManager.gain_score(1)
		await get_tree().create_timer(0.3).timeout
		hide()
		queue_free()
