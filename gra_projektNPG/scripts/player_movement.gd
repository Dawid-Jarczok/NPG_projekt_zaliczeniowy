extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
enum State  {default, run, jump}
var current_state
var state_before

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D

func _physics_process(delta):
	player_jump(delta)
	player_default(delta)
	player_run(delta)
	player_in_air(delta)
	move_and_slide()
	player_animations()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
func _ready():
	# Ustawienie nowej pozycji postaci
	position = Vector2(20, 20) # zamiast x i y wpisz odpowiednie wartości współrzędnych
	current_state = State.default

func player_default(delta):
	if is_on_floor():
		current_state = State.default

func player_jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func player_in_air(delta):
	if not is_on_floor():
		current_state = State.jump
		state_before = State.jump

func player_run(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction < 0:
		current_state = State.run
		sprite.flip_h = true
	elif direction > 0:
		current_state = State.run
		sprite.flip_h = false	

func player_animations():
	if current_state == State.default:
		sprite.play("default")
	elif current_state == State.jump:
		sprite.play("jump")
	elif current_state == State.run and is_on_floor():
		sprite.play("run")