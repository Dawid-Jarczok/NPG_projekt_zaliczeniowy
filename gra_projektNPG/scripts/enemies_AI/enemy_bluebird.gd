extends CharacterBody2D


var speed = -200.0
@onready var bluebird = $AnimatedSprite2D
var direction = true

func _physics_process(delta):
	velocity.y = 0.0

	if direction:
		velocity.x = -speed
	else:
		velocity.x = speed
	
	bluebird.flip_h = direction

	move_and_collide(velocity * delta)
	#move_and_slide()

func _on_timer_timeout():
	direction = !direction

func die():
	bluebird.play("dying")
	GameManager.gain_score(1)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	velocity.x = 0.0
	speed = 0.0
	await get_tree().create_timer(1.0).timeout
	bluebird.hide()
	queue_free()
	
	move_and_slide()



func _on_area_right_body_entered(body:Node2D):
	direction = false


func _on_area_left_body_entered(body:Node2D):
	direction = true

func _on_area_up_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		die()
