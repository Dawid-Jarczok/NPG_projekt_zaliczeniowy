extends CharacterBody2D

var speed = -60.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Enemy = $AnimatedSprite2D
@onready var collision_vector_1 = $RayCast2D_1
@onready var collision_vector_2 = $RayCast2D_2
@onready var collision_vector_up1 = $RayCast2D_up1
@onready var collision_vector_up2 = $RayCast2D_up2


var facing_left = true
var facing_right = false

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if facing_left:
		velocity.x = speed

	if facing_right:
		velocity.x = -speed

	if collision_vector_1.is_colliding():
		facing_left = false
		facing_right = true
		Enemy.flip_h = true

	if collision_vector_2.is_colliding():
		facing_left = true
		facing_right = false
		Enemy.flip_h = false

	if collision_vector_up1.is_colliding() or collision_vector_up2.is_colliding():
		Enemy.play("dying")

	move_and_slide()

