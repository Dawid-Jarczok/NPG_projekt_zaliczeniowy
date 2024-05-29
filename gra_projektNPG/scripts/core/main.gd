extends Node

@export var available_levels : Array[LevelData]

@onready var _2d_scene = $"2DScene"

func _ready():
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = available_levels
