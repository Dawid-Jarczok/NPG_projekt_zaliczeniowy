extends CharacterBody2D


var speed = -200.0
@onready var bluebird = $AnimatedSprite2D
@onready var collision_vector_right1 = $collision_right_1
@onready var collision_vector_right2 = $collision_right_2
@onready var collision_vector_left1 = $collision_left_1
@onready var collision_vector_left2 = $collision_left_2
@onready var collision_vector_up1 = $collision_up_1
@onready var collision_vector_up2 = $collision_up_2
var facing_left = true
var facing_right = false

func _physics_process(delta):
	velocity.y = 0.0

	if facing_left:
		velocity.x = speed

	if facing_right:
		velocity.x = -speed

	if collision_vector_left1.is_colliding() or collision_vector_left2.is_colliding():
		facing_left = false
		facing_right = true
		bluebird.flip_h = true

	if collision_vector_right1.is_colliding() or collision_vector_right2.is_colliding():
		facing_left = true
		facing_right = false
		bluebird.flip_h = false

	if collision_vector_up1.is_colliding() or collision_vector_up2.is_colliding():
		die()

	move_and_collide(velocity * delta)
	#move_and_slide()

func _on_timer_timeout():
	facing_left = !facing_left
	facing_right = !facing_right
	bluebird.flip_h = !bluebird.flip_h

func die():
	bluebird.play("dying")
	GameManager.gain_score(1)
	collision_vector_up1.enabled = false
	collision_vector_up2.enabled = false
	set_collision_mask_value(1, false)
	velocity.x = 0.0
	speed = 0.0
	await get_tree().create_timer(1.0).timeout
	bluebird.hide()
	queue_free()
	
	move_and_slide()
