extends CharacterBody2D

var speed = -60.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Enemy = $AnimatedSprite2D

var facing_dir= true

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if facing_dir:
		velocity.x = -speed
	else:
		velocity.x = speed

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
