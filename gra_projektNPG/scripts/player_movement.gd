class_name Player
extends CharacterBody2D


const SPEED = 340.0
const JUMP_VELOCITY = -750.0
const MAX_FALL_SPEED = 850.0
const DUST_MIN_VELOCITY = 450.0
const DAMAGE_VEL_X = 300.0
const DAMAGE_VEL_Y = -450.0

@export var gravity_multiplier : float = 1.7

var block_movement_inputs : bool = false
var block_damage : bool = false

enum State  {default, run, jump, falling}
var current_state = State
var if_was_falling: bool = true
var falling_vel: float = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var dust = get_node("/root/Map1/Player/Dust")

func _physics_process(delta):
	if Input.is_action_just_pressed("TestAction"):
		teleport()

	player_jump(delta)
	player_default(delta)
	player_run(delta)
	player_in_air(delta)
	player_falling(delta)
	dust_after_falling()
	move_and_slide()
	player_animations()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * gravity_multiplier * delta
		falling_vel = velocity.y
  #Change speed fall
	velocity.y = clamp(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)

func _ready():
	current_state = State.default
	GameManager.checkpoint = get_node("/root/Map1/PlayerStart").global_position


func player_default(delta):
	if is_on_floor():
		current_state = State.default

func player_falling(delta):
	if not is_on_floor() and velocity.y > 0:
		current_state = State.falling


func player_jump(delta):
	if block_movement_inputs:
		return
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func player_in_air(delta):
	if not is_on_floor() and velocity.y < 0:
		current_state = State.jump

func player_run(delta):
	# Blocking movement input for while after player taked damage
	if !block_movement_inputs:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	#Changing the character's direction 
	if velocity.x < 0:
		current_state = State.run
		sprite.flip_h = true
	elif velocity.x > 0:
		current_state = State.run
		sprite.flip_h = false	


func respawn():
	block_movement_inputs = false
	prints("Teleported to: ", GameManager.checkpoint)
	#dying animation
	await get_tree().create_timer(0.2).timeout
	velocity.x = 0.0
	velocity.y = 0.0
	global_position = GameManager.checkpoint
	GameManager.lose_scoore()
	GameManager.set_health(GameManager.BEGIN_HEALTH)

func teleport2checkpoint():
	if GameManager.take_damage():
		respawn()
		return
	GameManager.lose_scoore()
	velocity.x = 0.0
	velocity.y = 0.0
	prints("Teleported to: ", GameManager.checkpoint)
	global_position = GameManager.checkpoint

func player_animations():
	if current_state == State.default:
		sprite.play("default")
	elif current_state == State.jump and block_movement_inputs == false:
		sprite.play("jump")
	elif current_state == State.run and is_on_floor():
		sprite.play("run")
	elif current_state == State.falling and block_movement_inputs == false:
		sprite.play("falling")
	elif block_movement_inputs == true:
		sprite.play("player_hit")

func take_damage(damage, jump : Vector2):
	if block_damage: return
	block_damage = true
	block_movement_inputs  = true
	if jump.x == 1:
		velocity.x = DAMAGE_VEL_X
	else:
		velocity.x = -DAMAGE_VEL_X
	
	if jump.y == 1:
		velocity.y = DAMAGE_VEL_Y
	else:
		velocity.y = -DAMAGE_VEL_Y
	$TakedDamageTimer.start()
	if GameManager.take_damage():
		respawn()

func _on_taked_damage_timer_timeout():
	block_movement_inputs = false
	block_damage = false

func teleport():
	var new_pos = get_node("/root/Map1/DebugTeleport")
	print(new_pos.global_position)
	if new_pos:
		global_position = new_pos.global_position

func dust_after_falling():
	if not is_on_floor():
		if_was_falling = true
	else:
		if if_was_falling:
			if_was_falling = false
			if falling_vel < DUST_MIN_VELOCITY: return
			dust.global_position = global_position + Vector2(0, 18)
			dust.play("dust")
			await get_tree().create_timer(0.15).timeout
			dust.play("default")
			


func _on_area_up_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Trap"):
		take_damage(10, Vector2(sprite.flip_h, 1))


func _on_area_down_body_entered(body):
	if body.is_in_group("Trap"):
		take_damage(10, Vector2(sprite.flip_h, 1))


func _on_area_left_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Trap"):
		take_damage(10, Vector2(1, 1))


func _on_area_right_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Trap"):
		take_damage(10, Vector2(-1, 1))
