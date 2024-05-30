extends HBoxContainer

var heart_full = preload("res://scenes/Life/heart_gui.tscn")

func _ready():
	GameManager.health_changed.connect(update)
	update(GameManager.BEGIN_HEALTH)


func _process(delta):
	pass

func update(value):
	for i in get_child_count():
		get_child(i).visible = value > i