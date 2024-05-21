class_name Player
extends CharacterBody2D


const SPEED = 340.0
const JUMP_VELOCITY = -750.0
const MAX_FALL_SPEED = 850.0
const DUST_MIN_VELOCITY = 450.0
const DAMAGE_VEL_X = 300.0
const DAMAGE_VEL_Y = -400.0
const MAX_HEALTH = 100

@export var gravity_multiplier : float = 1.7
@export var health : int = MAX_HEALTH

var block_movement_inputs : bool = false

enum State  {default, run, jump, falling}
var current_state = State
var collider_name = null
var Enemies = ["Enemy_mushroom", "Enemy_mushroom2","Enemy_mushroom3","Enemy_mushroom4","Enemy_mushroom5","Enemy_mushroom6", "enemy_bluebird", "Bat"]
var Traps = ["Saw", "Spikes"]
var if_was_falling: bool = true
var falling_vel: float = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var left_col_vec_1 = $collision_left_1
@onready var left_col_vec_2 = $collision_left_2
@onready var left_col_vec_3 = $collision_left_3
@onready var right_col_vec_1 = $collision_right_1
@onready var right_col_vec_2 = $collision_right_2
@onready var right_col_vec_3 = $collision_right_3
@onready var down_col_vec_1 = $collision_down_1
@onready var down_col_vec_2 = $collision_down_2
@onready var down_col_vec_3 = $collision_down_3
@onready var up_col_vec_1 = $collision_up_1
@onready var up_col_vec_2 = $collision_up_2
@onready var up_col_vec_3 = $collision_up_3
@onready var dust = get_node("/root/Map1/player_test/Dust")

func _physics_process(delta):
	if Input.is_action_just_pressed("TestAction"):
		teleport()

	player_jump(delta)
	player_default(delta)
	player_run(delta)
	player_in_air(delta)
	player_falling(delta)
	who_hit_player_on_left()
	who_hit_player_on_right()
	who_hit_player_on_bottom()
	who_hit_player_from_top()
	dust_after_falling()
	player_taked_damage(delta)
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

func player_taked_damage(delta):
	if !block_movement_inputs:
		return
	
	# Player after taking damage jumps away from enemie there when touched ground should stop moving
	if is_on_floor():
		velocity.x = 0.0

func respawn():
	health = MAX_HEALTH
	block_movement_inputs = false
	print(GameManager.checkpoint)
	global_position = GameManager.checkpoint
	velocity.x = 0.0
	velocity.y = 0.0

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

func take_damage(damage):
	if block_movement_inputs: return
	block_movement_inputs = true
	$TakedDamageTimer.start()
	health -= damage
	prints("Player health:", health)
	if health <= 0:
		respawn()

func who_hit_player_on_left():
	if left_col_vec_1.is_colliding():
		collider_name = left_col_vec_1.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null
	if left_col_vec_2.is_colliding():
		collider_name = left_col_vec_2.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null
	if left_col_vec_3.is_colliding():
		collider_name = left_col_vec_3.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null

func who_hit_player_on_right():
	if right_col_vec_1.is_colliding():
		collider_name = right_col_vec_1.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = -DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null
	if right_col_vec_2.is_colliding():
		collider_name = right_col_vec_2.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = -DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null
	if right_col_vec_3.is_colliding():
		collider_name = right_col_vec_3.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = -DAMAGE_VEL_X
			velocity.y = DAMAGE_VEL_Y
	else:
		collider_name = null

func who_hit_player_on_bottom():
	if down_col_vec_1.is_colliding():
		collider_name = down_col_vec_1.get_collider().name
		if Traps.has(collider_name):
			take_damage(10)
			velocity.y = DAMAGE_VEL_Y
			await get_tree().create_timer(0.05).timeout
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
	else:
		collider_name = null
	if down_col_vec_2.is_colliding():
		collider_name = down_col_vec_2.get_collider().name
		if Traps.has(collider_name):
			take_damage(10)
			velocity.y = DAMAGE_VEL_Y
			await get_tree().create_timer(0.05).timeout
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
	else:
		collider_name = null
	if down_col_vec_3.is_colliding():
		collider_name = down_col_vec_3.get_collider().name
		if Traps.has(collider_name):
			take_damage(10)
			velocity.y = DAMAGE_VEL_Y
			await get_tree().create_timer(0.05).timeout
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
	else:
		collider_name = null

func who_hit_player_from_top():
	if up_col_vec_1.is_colliding():
		collider_name = up_col_vec_1.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
			velocity.y = -DAMAGE_VEL_Y
	else:
		collider_name = null
	if up_col_vec_2.is_colliding():
		collider_name = up_col_vec_2.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
			velocity.y = -DAMAGE_VEL_Y
	else:
		collider_name = null
	if up_col_vec_3.is_colliding():
		collider_name = up_col_vec_3.get_collider().name
		if Enemies.has(collider_name) or Traps.has(collider_name):
			take_damage(10)
			velocity.x = DAMAGE_VEL_X
			if sprite.flip_h == true: velocity.x = -velocity.x 
			velocity.y = -DAMAGE_VEL_Y
	else:
		collider_name = null

func _on_taked_damage_timer_timeout():
	block_movement_inputs = false

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
			
