extends Node

func _ready():
	GameManager.gained_score.connect(update_score_display)

func _process(delta):
	$FPSMeter.text = "FPS: " + str(Engine.get_frames_per_second())
	#var fps = 1.0 / delta
	#$FPSMeter.text = "FPS: %.0f" % fps

func update_score_display(gained_score):
	$ScoreDisplay.text = "Score: " + str(GameManager.score)
