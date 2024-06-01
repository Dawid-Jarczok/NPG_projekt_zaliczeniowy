extends Control

func _ready():
	visible = GameManager.game_paused
	GameManager.game_pause.connect(pause_menu)

func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	GameManager.resume_game()

func pause_menu(_pause):
	visible = _pause