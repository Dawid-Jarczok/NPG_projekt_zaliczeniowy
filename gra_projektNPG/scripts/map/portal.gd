@tool
extends Node2D

@export var teleport_to_level_id: int = 0:
	set(lvl_id):
		teleport_to_level_id = lvl_id
		print("Teleport set to: ", teleport_to_level_id)


func _on_portal_area_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		emit_signal("entered portal")
		prints("Teleporting to level: ", teleport_to_level_id)
		await get_tree().create_timer(1.0).timeout
		LevelManager.load_level(teleport_to_level_id)
