extends CharacterBody2D

var flying_speed = 50.0
var attacking_speed = 800.0
var get_back_speed = 500.0
var facing_left = true
var facing_right = false
var counter = 1
var collider_name 
var attack = false
@onready var Bee = $AnimatedSprite2D
@onready var col_vect_down_1 = $collision_down_1
@onready var col_vect_down_2 = $collision_down_2
@onready var col_vect_down_3 = $collision_down_3
@onready var col_vect_up_1 = $collision_up_1
@onready var col_vect_up_2 = $collision_up_2

var on_screen:bool = false

func _ready():
	enemy_pause(true)
	GameManager.game_pause.connect(enemy_pause)

func enemy_pause(_pause):
	if _pause:
		set_process(false)
		set_physics_process(false)
		set_process_unhandled_input(false)
		set_process_input(false)
	else:
		if on_screen:
			set_process(true)
			set_physics_process(true)
			set_process_unhandled_input(true)
			set_process_input(true)

func _physics_process(delta):

	if facing_left and !attack:
		velocity.x = flying_speed

	if facing_right and !attack:
		velocity.x = -flying_speed
	
	if counter == 4:
		attack = true
		Bee.play("attacking")
		velocity.y = attacking_speed
		velocity.x = 0
		if col_vect_down_1.is_colliding() or col_vect_down_2.is_colliding() or col_vect_down_3.is_colliding():
			velocity.y = 0
			die()
			counter += 1

	if col_vect_up_1.is_colliding() or col_vect_up_2.is_colliding():
		die()
	move_and_slide()


func _on_timer_timeout():
	facing_left = !facing_left
	facing_right = !facing_right
	Bee.flip_h = !Bee.flip_h

func _on_area_2d_body_entered(body):
	counter += 1

func die():
	Bee.play("dying")
	GameManager.gain_score(1)
	col_vect_up_1.enabled = false
	col_vect_up_2.enabled = false
	set_collision_mask_value(1, false)
	await get_tree().create_timer(1.0).timeout
	Bee.hide()
	queue_free()
	
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true
	enemy_pause(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false
	enemy_pause(true)
