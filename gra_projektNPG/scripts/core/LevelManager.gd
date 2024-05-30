extends Node

var levels : Array[LevelData]

var main_scene : Node2D = null
var loaded_level : Level = null

func unload_level() -> void:
	if is_instance_valid(loaded_level):
		loaded_level.queue_free()
	
	loaded_level = null

func load_level(level_id : int) -> void:
	prints("Loading level: ", level_id)
	unload_level()

	var level_data = get_level_data_by_id(level_id)

	if not level_data:
		print("Error loading level")
		return
	
	var level_path = "res://scenes/%s.tscn" % level_data.level_path
	var level_res = load(level_path)

	if level_res:
		loaded_level = level_res.instantiate()

		main_scene.add_child(loaded_level)
	else:
		print("Level does not exist")

func get_level_data_by_id(id : int) -> LevelData:
	var level_to_return : LevelData = null

	for lvl : LevelData in levels:
		if lvl.level_id == id:
			level_to_return = lvl
	
	return level_to_return

func get_current_level() -> Level:
	return loaded_level

func pause_game() -> void:
	#var level_data = get_level_data_by_id(loaded_level.level_id)
	#var level_path = "res://scenes/%s.tscn" % level_data.level_path
	#level_path.pause()
	#get_tree().paused = true
	print("Game paused")

func resume_game() -> void:
	print("Game resumed")
	#get_tree().paused = false

func is_game_paused() -> bool:
	return loaded_level.get_tree().paused