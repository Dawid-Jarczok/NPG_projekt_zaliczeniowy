extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var max_fall_speed = 600
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var spawnPoint

@onready var sprite = $Sprite2D

func _physics_process(delta):
	if Input.is_action_just_pressed("TestAction"):
		respawn()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	#Change speed fall
	velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#Changing the character's direction 
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false	
	move_and_slide()

func _ready():
	spawnPoint = get_node("/root/Map1/PlayerStart")

func respawn():
	spawnPoint = get_node("/root/Map1/PlayerStart")
	print(spawnPoint.global_position)
	if spawnPoint:
		global_position = spawnPoint.global_position