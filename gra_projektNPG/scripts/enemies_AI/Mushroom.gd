extends CharacterBody2D

const SPEED_MIN = 50.0
const SPEED_MAX = 100.0

var speed:float = SPEED_MIN
var facing_dir:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Enemy = $AnimatedSprite2D
@onready var ground_detection_left = $Ground_detection_left
@onready var ground_detection_right = $Ground_detection_right

func _ready():
	GameManager.game_pause.connect(enemy_pause)
	facing_dir = randi_range(0, 1)
	speed = randf_range(SPEED_MIN, SPEED_MAX)

func enemy_pause(_pause):
	if _pause:
		set_process(false)
		set_physics_process(false)
		set_process_unhandled_input(false)
		set_process_input(false)
	else:
		set_process(true)
		set_physics_process(true)
		set_process_unhandled_input(true)
		set_process_input(true)


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if !ground_detection_left.is_colliding() or !ground_detection_right.is_colliding():
		facing_dir = !facing_dir

	if facing_dir:
		velocity.x = speed
	else:
		velocity.x = -speed

	Enemy.flip_h = facing_dir

	move_and_slide()

func die():
	Enemy.play("dying")
	GameManager.gain_score(1)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	velocity.x = 0.0
	speed = 0.0
	await get_tree().create_timer(1.5).timeout
	Enemy.hide()
	queue_free()


func _on_area_up_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		die()

func _on_area_right_body_entered(body:Node2D):
	facing_dir = false

func _on_area_left_body_entered(body:Node2D):
	facing_dir = true
