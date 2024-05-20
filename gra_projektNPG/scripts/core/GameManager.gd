extends Node

signal gained_score(int)

var player : Player

var score : int = 0

func gain_score(score_gained):
	score += score_gained
	emit_signal("gained_score", score_gained)
	prints("Score: ", score)
