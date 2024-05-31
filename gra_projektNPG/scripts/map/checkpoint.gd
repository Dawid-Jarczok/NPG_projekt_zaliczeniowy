extends Node2D


func _on_checkpoint_area_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		GameManager.set_checkpoint(global_position + Vector2(0, -40))
