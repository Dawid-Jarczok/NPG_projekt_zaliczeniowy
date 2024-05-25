extends Area2D


func _on_body_entered(body:Node2D):
	print("Entered danger zone")
	if body.is_in_group("Player"):
		body.teleport2checkpoint()
