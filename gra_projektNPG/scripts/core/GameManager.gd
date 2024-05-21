extends Node

signal gained_score(int)

var player : Player

var score : int = 0
var checkpoint : Vector2 = Vector2.ZERO

func gain_score(score_gained):
	score += score_gained
	emit_signal("gained_score", score_gained)
	prints("Score: ", score)


func set_checkpoint(position : Vector2):
	checkpoint = position
	prints("Set checkpoint: ", str(checkpoint))