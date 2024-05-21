extends Node

func _ready():
	GameManager.gained_score.connect(update_score_display)
	$heartsContainer.setMaxHearts(5)

func _process(delta):
	$FPSMeter.text = "FPS: " + str(Engine.get_frames_per_second())

func update_score_display(gained_score):
	$ScoreDisplay.text = "Score: " + str(GameManager.score)
