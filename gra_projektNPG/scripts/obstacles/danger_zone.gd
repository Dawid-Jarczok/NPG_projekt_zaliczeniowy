extends Area2D


func _on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		print("Entered danger zone")
		body.teleport2checkpoint()
