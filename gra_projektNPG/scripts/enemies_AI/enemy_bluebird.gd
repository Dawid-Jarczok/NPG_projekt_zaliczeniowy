extends CharacterBody2D


var speed = -200.0
@onready var bluebird = $AnimatedSprite2D
@onready var area_left = $Area_left
var direction = true
var on_screen:bool = false

func _ready():
	enemy_pause(true)
	GameManager.game_pause.connect(enemy_pause)

func enemy_pause(_pause):
	if _pause:
		bluebird.pause()
		set_process(false)
		set_physics_process(false)
		set_process_unhandled_input(false)
		set_process_input(false)
	else:
		if on_screen:
			bluebird.play("default")
			set_process(true)
			set_physics_process(true)
			set_process_unhandled_input(true)
			set_process_input(true)


func _physics_process(delta):
	velocity.y = 0.0

	if direction:
		velocity.x = -speed
	else:
		velocity.x = speed
	
	bluebird.flip_h = direction

	move_and_collide(velocity * delta)
	#move_and_slide()

func die():
	bluebird.play("dying")
	GameManager.gain_score(5)
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


func _on_flying_area_area_exited(area:Area2D):
	if area == $Area_right:
		direction = false
	elif area == $Area_left:
		direction = true


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true
	enemy_pause(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false
	enemy_pause(true)