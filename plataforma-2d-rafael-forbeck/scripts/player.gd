extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	duck,
	slide,
	death
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_normal: CollisionShape2D = $CollisionNormal
@onready var collision_duck: CollisionShape2D = $CollisionDuck
@onready var hitbox: Area2D = $Hitbox

@export var max_speed = 90.0
@export var acceleration = 500
@export var deceleration = 500
@export var slide_deceleration = 75

const JUMP_VELOCITY = -300.0
var jump_count = 0
@export var max_jump_count = 2

var direction = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	# A gravidade agora roda aqui para todos os estados de forma global
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.slide:
			slide_state(delta)
		PlayerState.death:
			death_state(delta)
	move_and_slide()

#   ____  ___   _____ ___    _________  _____ _____   _____ ____   ___  __  __ 
#  / ___|/ _ \ |_   _/ _ \  / / ____\ \/ /_ _|_   _| |  ___|  _ \ / _ \|  \/  |
# | |  _| | | |  | || | | |/ /|  _|  \  / | |  | |   | |_  | |_) | | | | |\/| |
# | |_| | |_| |  | || |_| / / | |___ /  \ | |  | |   |  _| |  _ <| |_| | |  | |
#  \____|\___/___|_| \___/_/  |_____/_/\_\___| |_|___|_|   |_| \_\\___/|_|  |_|
#           |_____|                             |_____|                        

# --- TRANSITION FUNCTIONS (STATE CHANGE) ---
func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY # Apply the momentum from the jump right at the transition!
	jump_count += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")
	set_small_collider()
	
func exit_from_duck_state():
	set_normal_collider()

func go_to_slide_state():
	status = PlayerState.slide
	anim.play("slide")
	set_small_collider()

func exit_from_slide_state():
	set_normal_collider()
	
func go_to_death_state():
	status = PlayerState.death
	anim.play("death")
	velocity = Vector2.ZERO

#      ____ _____  _  _____ _____     ____ _____  _  _____ _____ 
#     / ___|_   _|/ \|_   _| ____|   / ___|_   _|/ \|_   _| ____|
#     \___ \ | | / _ \ | | |  _|     \___ \ | | / _ \ | | |  _|  
#      ___) || |/ ___ \| | | |___     ___) || |/ ___ \| | | |___ 
# ____|____/ |_/_/   \_\_| |_____|___|____/ |_/_/   \_\_| |_____|
#|_____|                        |_____|                              
				   
# --- BEHAVIORS OF EACH STATE ---
func idle_state(delta):
	move(delta)
	
	# Condition to start walking
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	# Condition to skip (Correction of the Input method)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return

func walk_state(delta):
	move(delta)
	
	# Condition to return to standstill (Indentation correction)
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	# Condition for jumping even while running
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_state()
		return
		
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
	
	if Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return

func jump_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
		
	if velocity.y > 0:
		go_to_fall_state()
		return


func fall_state(delta):
	move(delta)

	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return

	# Jump exit condition: When touching the ground again
	if is_on_floor():
		jump_count = 0
		if velocity.x != 0:
			go_to_walk_state()
		else:
			go_to_idle_state()
		return

func duck_state(_delta):
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
		
func slide_state(delta):
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)
	
	if Input.is_action_just_released("duck"):
		exit_from_slide_state()
		go_to_walk_state()
		return

	if velocity.x == 0:
		exit_from_slide_state()
		go_to_duck_state()
		return


func death_state(_delta):
	pass
# --- AUXILIARY MOVEMENT FUNCTION (Now separate from other functions) ---
func move(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
		
func can_jump() -> bool:
	return jump_count < max_jump_count

# Disables the stading collider and enables the crouching collider
func set_small_collider():
	collision_normal.set_deferred("disabled", true)
	collision_duck.set_deferred("disabled", false)

# Do the opposite: return the collider to the upright positon
# and deactivate the crouching position
func set_normal_collider():
	collision_normal.set_deferred("disabled",false)
	collision_duck.set_deferred("disabled",true)
	
func fall_and_slide():
	if velocity.y > 0:
		go_to_fall_state()
	elif Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return


func _on_hitbox_area_entered(area: Area2D) -> void:
	# If the Y velocity is greater than 0, the player is FALLING on the enemy's head.
	if velocity.y > 0:
		#Enemy dead
		area.get_parent().take_damage()
		go_to_jump_state()
	else:
		#Player dead
		go_to_death_state()
