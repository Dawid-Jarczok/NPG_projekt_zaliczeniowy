extends Node

const BEGIN_HEALTH = 5
const MAX_HEALTH = 10

signal gained_score(int)
signal health_changed(int)
signal health_set(int)

var player : Player

var score : int = 0
var health : int = BEGIN_HEALTH
var checkpoint : Vector2 = Vector2.ZERO

func _ready():
	pass

func gain_score(score_gained):
	score += score_gained
	emit_signal("gained_score", score_gained)
	prints("Score: ", score)

func lose_scoore():
	gain_score((-score) * 0.33)

func set_checkpoint(position : Vector2):
	checkpoint = position
	prints("Set checkpoint: ", str(checkpoint))

func set_health(_health : int):
	health = _health
	clamp(health, 0, MAX_HEALTH)
	emit_signal("health_changed", health)


# returns true if health is 0
func take_damage():
	health -= 1
	emit_signal("health_changed", health)
	prints("Player health:", health)
	if health <= 0: return true
	return false