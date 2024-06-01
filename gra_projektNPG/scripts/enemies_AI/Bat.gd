extends CharacterBody2D
var speed = 210.0
var player = null
enum State  {default, chase, fly2ceiling, push}
var state = State
var timer
var collider_name = null
@onready var Bat = $AnimatedSprite2D
@onready var col_vect_down_1 = $collision_down_1
@onready var col_vect_down_2 = $collision_down_2

var on_screen:bool = false

func _ready():
	enemy_pause(true)
	GameManager.game_pause.connect(enemy_pause)
	state = State.default
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)

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
	if state == State.chase:
		velocity = position.direction_to(player.global_position) * speed
		
		if velocity.x > 0: Bat.flip_h = true;
		else: Bat.flip_h = false
			
	elif state == State.fly2ceiling:
		velocity.x = 0.0
		velocity.y = -speed
			
	elif state == State.push:
		velocity *= 0.93

	animations()

	move_and_slide()
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i).get_collider().is_in_group("Player"):
			velocity = -position.direction_to(player.global_position) * speed * 3
			state = State.push
			timer.start()

func _on_timer_timeout():
	if state == State.push:
		state = State.chase

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		state = State.chase

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		state = State.fly2ceiling

func die():
	Bat.play("dying")
	GameManager.gain_score(10)
	set_collision_mask_value(1, false)
	velocity.x = 0.0
	speed = 0.0
	await get_tree().create_timer(0.5).timeout
	Bat.hide()
	queue_free()

func animations():
	if state == State.default:
		Bat.play("default")
	else:
		Bat.play("chasing")

func _on_area_up_body_entered(body:Node2D):
	if state == State.fly2ceiling:
		if body.is_in_group("Map"):
			state = State.default
	elif state == State.chase or state == State.push:
		if body.is_in_group("Player"):
			die()



func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true
	enemy_pause(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false
	enemy_pause(true)