extends CharacterBody2D
var speed = 210.0
var player = null
var player_chase = false
var counter = 0
var collider_name = null
@onready var Bat = $AnimatedSprite2D
@onready var col_vect_up_1 = $collision_up_1
@onready var col_vect_up_2 = $collision_up_2
@onready var col_vect_down_1 = $collision_down_1
@onready var col_vect_down_2 = $collision_down_2

func _physics_process(delta):
	if player_chase and counter >= 3:
		Bat.play("chasing")
		velocity = Vector2.ZERO
		velocity = position.direction_to(player.global_position) * speed
		if col_vect_up_1.is_colliding() and col_vect_up_1.get_collider().name == "CharacterBody2D":
			die()
		if col_vect_up_2.is_colliding() and col_vect_up_2.get_collider().name == "CharacterBody2D":
			die()	
		move_and_slide()

func _on_detection_area_body_entered(body):
	counter += 1
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func die():
	Bat.play("dying")
	GameManager.gain_score(1)
	col_vect_up_1.enabled = false
	col_vect_up_2.enabled = false
	set_collision_mask_value(1, false)
	velocity.x = 0.0
	speed = 0.0
	await get_tree().create_timer(0.5).timeout
	Bat.hide()
	queue_free()
	
	move_and_slide()