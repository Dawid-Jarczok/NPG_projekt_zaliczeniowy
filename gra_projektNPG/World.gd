extends Node


@onready var heartsContainer = $CanvasLayer/heartsContainer
# Called when the node enters the scene tree for the first time.

func _ready():
	heartsContainer.setMaxHearts(5)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass