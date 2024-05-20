extends HBoxContainer

@onready var heartsGuiClass = preload("res://scenes/Life/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max_hp: int):
	for i in range (max_hp):
		var heart = heartsGuiClass.instantiate()
		add_child(heart)
