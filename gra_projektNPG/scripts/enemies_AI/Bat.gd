extends CharacterBody2D
var speed = 210.0
var player = null
enum State  {default, chase, fly2ceiling}
var state = State
var collider_name = null
@onready var Bat = $AnimatedSprite2D
@onready var col_vect_up_1 = $collision_up_1
@onready var col_vect_up_2 = $collision_up_2
@onready var col_vect_down_1 = $collision_down_1
@onready var col_vect_down_2 = $collision_down_2

func _ready():
	state = State.default

func _physics_process(delta):
	if state == State.chase:
		velocity = position.direction_to(player.global_position) * speed
		if velocity.x > 0: Bat.flip_h = true;
		else: Bat.flip_h = false

		if col_vect_up_1.is_colliding() and col_vect_up_1.get_collider().is_in_group("Player"):
			die()
		if col_vect_up_2.is_colliding() and col_vect_up_2.get_collider().is_in_group("Player"):
			die()	
	elif state == State.fly2ceiling:
		velocity.x = 0.0
		velocity.y = -speed
		if col_vect_up_1.is_colliding() and col_vect_up_1.get_collider().is_in_group("Map"):
			state = State.default
		if col_vect_up_2.is_colliding() and col_vect_up_2.get_collider().is_in_group("Map"):
			state = State.default
	
	animations()
	move_and_collide(velocity * delta)
	#move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		state = State.chase

func _on_detection_area_body_exited(body):
	player = null
	state = State.fly2ceiling

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

func animations():
	if state == State.chase or state == State.fly2ceiling:
		Bat.play("chasing")
	else:
		Bat.play("default")