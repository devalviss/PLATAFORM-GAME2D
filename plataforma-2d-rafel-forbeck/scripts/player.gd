extends CharacterBody2D

enum PlayerState{
	Idle,
	Walk,
	Jump,
	Duck,
	Fall,
	Slide,
	Death,
	Wall
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var collision_hitbox: CollisionShape2D = $Hitbox/CollisionHitbox
@onready var reload_timer: Timer = $ReloadTimer
@onready var left_wall_detector: RayCast2D = $LeftWallDetector
@onready var right_wall_detector: RayCast2D = $RightWallDetector

@export var max_speed = 100.0
@export var acceleration = 400
@export var deceleration = 400
@export var Slide_deceleration = 100
@export var max_Jump_count = 2
@export var wall_acceleration = 40
@export var wall_jump_velocity = 250

const JUMP_VELOCITY = -200.0
var status: PlayerState
var direction = 0
var Jump_count = 0

func _ready() -> void:
	go_to_Idle_state()

func _physics_process(delta: float) -> void:
	
	
	match status:
		PlayerState.Idle:
			Idle_state(delta)
		PlayerState.Walk:
			Walk_state(delta)
		PlayerState.Jump:
			Jump_state(delta)
		PlayerState.Duck:
			Duck_state(delta)
		PlayerState.Fall:
			Fall_state(delta)
		PlayerState.Slide:
			Slide_state(delta)
		PlayerState.Death:
			Death_state(delta)
		PlayerState.Wall:
			Wall_state(delta)
	move_and_slide()

#   ____  ___   _____ ___    _________  _____ _____   _____ ____   ___  __  __ 
#  / ___|/ _ \ |_   _/ _ \  / / ____\ \/ /_ _|_   _| |  ___|  _ \ / _ \|  \/  |
# | |  _| | | |  | || | | |/ /|  _|  \  / | |  | |   | |_  | |_) | | | | |\/| |
# | |_| | |_| |  | || |_| / / | |___ /  \ | |  | |   |  _| |  _ <| |_| | |  | |
#  \____|\___/___|_| \___/_/  |_____/_/\_\___| |_|___|_|   |_| \_\\___/|_|  |_|
#           |_____|                             |_____|                        

func go_to_Idle_state():
	status = PlayerState.Idle
	anim.play("Idle")

func go_to_Walk_state():
	status = PlayerState.Walk
	anim.play("Walk")

func go_to_Jump_state():
	status = PlayerState.Jump
	velocity.y = JUMP_VELOCITY
	anim.play("Jump")
	Jump_count += 1

func go_to_Duck_state():
	status = PlayerState.Duck
	anim.play("Duck")
	set_small_collider()

func exit_from_Duck_state():
	set_large_collider()

func go_to_Fall_state():
	status = PlayerState.Fall
	anim.play("Fall")

func go_to_Slide_state():
	status = PlayerState.Slide
	anim.play("Slide")
	set_small_collider()

func exit_from_Slide_state():
	set_large_collider()

func go_to_Death_state():
	if status == PlayerState.Death:
		return
		
	status = PlayerState.Death
	anim.play("Death")
	velocity.x = 0
	reload_timer.start()

func go_to_Wall_state():
	status = PlayerState.Wall
	anim.play("Wall")
	set_small_collider()
	velocity = Vector2.ZERO
	Jump_count = 0

#       ____ _____  _  _____ _____    __ ____ _____  _  _____ _____ 
#      / ___|_   _|/ \|_   _| ____|  / // ___|_   _|/ \|_   _| ____|
#      \___ \ | | / _ \ | | |  _|   / / \___ \ | | / _ \ | | |  _|  
#       ___) || |/ ___ \| | | |___ / /   ___) || |/ ___ \| | | |___ 
#  ____|____/ |_/_/   \_\_| |_____/_/___|____/ |_/_/   \_\_| |_____|
# |_____|                          |_____|                          

func Idle_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x != 0:
		go_to_Walk_state()
		return

	if Input.is_action_just_pressed("Jump"):
		go_to_Jump_state()
		return

	if Input.is_action_pressed("Duck"):
		go_to_Duck_state()
		return

func Walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x == 0:
		go_to_Idle_state()
		return

	if Input.is_action_just_pressed("Jump"):
		go_to_Jump_state()
		return

	if !is_on_floor():
		Jump_count += 1
		go_to_Fall_state()
		return

	if Input.is_action_just_pressed("Duck"):
		go_to_Slide_state()
		return

func Jump_state(delta):
	apply_gravity(delta)
	move(delta)

	if Input.is_action_just_pressed("Jump") &&  can_Jump():
		go_to_Jump_state()
		return

	if velocity.y > 0:
		go_to_Fall_state()
		return

func Duck_state(delta):
	apply_gravity(delta)
	# Permite capturar os botões Esquerda/Direita para virar o sprite parado
	update_direction()

	# CORREÇÃO: Força a velocidade X a ir para 0. 
	# Se ele vinha andando, ele vai parar imediatamente (ou deslizar só um pouquinho)
	velocity.x = move_toward(velocity.x, 0, max_speed)

	if Input.is_action_just_released("Duck"):
		exit_from_Duck_state()
		go_to_Idle_state()
		return

func Fall_state(delta):
	apply_gravity(delta)
	move(delta)

	if Input.is_action_just_pressed("Jump") &&  can_Jump():
		go_to_Jump_state()
		return

	if is_on_floor():
		Jump_count = 0
		if velocity.x == 0:
			go_to_Idle_state()
		else:
			go_to_Walk_state()
		return
	if (left_wall_detector.is_colliding() or right_wall_detector.is_colliding()) && is_on_wall():
		go_to_Wall_state()
		return

func Slide_state(delta):
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0,Slide_deceleration * delta)

	if Input.is_action_just_released("Duck"):
		exit_from_Duck_state()
		go_to_Walk_state()
		return

	if velocity.x == 0:
		exit_from_Slide_state()
		go_to_Duck_state()
		return

func Death_state(delta):
	apply_gravity(delta)

func Wall_state(delta):
	
	velocity.y += wall_acceleration * delta
	
	if left_wall_detector.is_colliding():
		anim.flip_h = false
		direction = 1
	elif right_wall_detector.is_colliding():
		anim.flip_h = true
		direction = -1
	else:
		go_to_Fall_state()
		return
	
	if is_on_floor():
		go_to_Idle_state()
		return
	
	if Input.is_action_just_pressed("Jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_Jump_state()
		return

#     _    ____ ____ ___ ____ _____  _    _   _ _____ ____  
#    / \  / ___/ ___|_ _/ ___|_   _|/ \  | \ | |_   _/ ___| 
#   / _ \ \___ \___ \| |\___ \ | | / _ \ |  \| | | | \___ \ 
#  / ___ \ ___) |__) | | ___) || |/ ___ \| |\  | | |  ___) |
# /_/   \_\____/____/___|____/ |_/_/   \_\_| \_| |_| |____/ 

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func move(delta):
	update_direction()

	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

func update_direction():
	direction = Input.get_axis("Left", "Right")

	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func can_Jump() -> bool:
	return Jump_count < max_Jump_count

func set_small_collider():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 3

	collision_hitbox.shape.size.y = 10
	collision_hitbox.position.y = 3.0

func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 16
	collision_shape.position.y = 0

	collision_hitbox.shape.size.y = 15
	collision_hitbox.position.y = 0.5

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		hit_enemy(area)
	elif area.is_in_group("Lethal_Area"):
		hit_lethal_area()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Lethal_Area"):
		go_to_Death_state()

func hit_enemy(area: Area2D):
	if global_position.y < area.global_position.y:
		area.get_parent().take_damage()
		velocity.y = JUMP_VELOCITY # quica automaticamente
	else:
		#Player morre
		go_to_Death_state()

func hit_lethal_area():
	if status != PlayerState.Death:
		go_to_Death_state()

func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
