extends CharacterBody2D


const SPEED = 100.0
@onready var collision_left = $collision_down
@onready var collision_right = $collision_up
var facing_left = true
var facing_right = false
var collider_name

func _physics_process(delta):

	if facing_left:
		velocity.y = SPEED
	if facing_right:
		velocity.y = - SPEED

	if collision_left.is_colliding():
		collider_name = collision_left.get_collider().name
		if collider_name == "TileMap":
			facing_left = !facing_left
			facing_right = !facing_right
			await get_tree().create_timer(0.3).timeout

	if collision_right.is_colliding():
		collider_name = collision_right.get_collider().name
		if collider_name == "TileMap":
			facing_left = !facing_left
			facing_right = !facing_right
			await get_tree().create_timer(0.3).timeout

	move_and_slide()
