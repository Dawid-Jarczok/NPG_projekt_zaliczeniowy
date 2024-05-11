class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const MAX_FALL_SPEED = 650

enum State  {default, run, jump, falling}
var current_state
var collider_name = null
var Enemies = ["Enemy_mushroom"]
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var spawnPoint

@onready var sprite = $Sprite2D
@onready var left_col_vec = $collision_left
@onready var right_col_vec = $collision_right

func _physics_process(delta):
	if Input.is_action_just_pressed("TestAction"):
		respawn()

	player_jump(delta)
	player_default(delta)
	player_run(delta)
	player_in_air(delta)
	player_falling(delta)
	who_hit_player_on_left()
	who_hit_player_on_right()
	move_and_slide()
	player_animations()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
  #Change speed fall
	velocity.y = clamp(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)

func _ready():
	# Ustawienie nowej pozycji postaci
	position = Vector2(20, 20) # zamiast x i y wpisz odpowiednie wartości współrzędnych
	current_state = State.default


func player_default(delta):
	if is_on_floor():
		current_state = State.default

func player_falling(delta):
	if not is_on_floor() and velocity.y > 0:
		current_state = State.falling


func player_jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func player_in_air(delta):
	if not is_on_floor() and velocity.y < 0:
		current_state = State.jump

func player_run(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#Changing the character's direction 
	if direction < 0:
		current_state = State.run
		sprite.flip_h = true
	elif direction > 0:
		current_state = State.run
		sprite.flip_h = false	


func respawn():
	spawnPoint = get_node("/root/Map1/PlayerStart")
	print(spawnPoint.global_position)
	if spawnPoint:
		global_position = spawnPoint.global_position
		velocity.x = 0.0
		velocity.y = 0.0

func player_animations():
	if current_state == State.default:
		sprite.play("default")
	elif current_state == State.jump:
		sprite.play("jump")
	elif current_state == State.run and is_on_floor():
		sprite.play("run")
	elif current_state == State.falling:
		sprite.play("falling")

func who_hit_player_on_left():
	if left_col_vec.is_colliding():
		collider_name = left_col_vec.get_collider().name
		if Enemies.has(collider_name):
			respawn()
	else:
		collider_name = null

func who_hit_player_on_right():
	if right_col_vec.is_colliding():
		collider_name = right_col_vec.get_collider().name
		if Enemies.has(collider_name):
			respawn()
	else:
		collider_name = null

