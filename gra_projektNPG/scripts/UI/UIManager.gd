extends Node

func _ready():
	GameManager.gained_score.connect(update_score_display)

func update_score_display(gained_score):
	$ScoreDisplay.text = "Score: " + str(GameManager.score)
