extends CharacterBody2D

enum SkeletonState{
	Idle,
	Walk,
	Death,
	Attack
}

const SPINING_BONE = preload("uid://pq1avhslujx1")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

const SPEED = 18.0
const JUMP_VELOCITY = -400.0
var status: SkeletonState
var direction = 1
var can_throw = true

func _ready() -> void:
	go_to_Walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		SkeletonState.Idle:
			Idle_state(delta)
		SkeletonState.Walk:
			Walk_state(delta)
		SkeletonState.Death:
			Death_state(delta)
		SkeletonState.Attack:
			Attack_state(delta)
	move_and_slide()

#   ____  ___   _____ ___    _________  _____ _____   _____ ____   ___  __  __ 
#  / ___|/ _ \ |_   _/ _ \  / / ____\ \/ /_ _|_   _| |  ___|  _ \ / _ \|  \/  |
# | |  _| | | |  | || | | |/ /|  _|  \  / | |  | |   | |_  | |_) | | | | |\/| |
# | |_| | |_| |  | || |_| / / | |___ /  \ | |  | |   |  _| |  _ <| |_| | |  | |
#  \____|\___/___|_| \___/_/  |_____/_/\_\___| |_|___|_|   |_| \_\\___/|_|  |_|
#           |_____|                             |_____|                        

func go_to_Idle_state():
	status = SkeletonState.Idle
	anim.play("Idle")

func go_to_Walk_state():
	status = SkeletonState.Walk
	anim.play("Walk")

func go_to_Death_state():
	status = SkeletonState.Death
	anim.play("Death")
	velocity = Vector2.ZERO
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func go_to_Attack_state():
	status = SkeletonState.Attack
	anim.play("Attack")
	velocity = Vector2.ZERO
	can_throw = true

#       ____ _____  _  _____ _____    __ ____ _____  _  _____ _____ 
#      / ___|_   _|/ \|_   _| ____|  / // ___|_   _|/ \|_   _| ____|
#      \___ \ | | / _ \ | | |  _|   / / \___ \ | | / _ \ | | |  _|  
#       ___) || |/ ___ \| | | |___ / /   ___) || |/ ___ \| | | |___ 
#  ____|____/ |_/_/   \_\_| |_____/_/___|____/ |_/_/   \_\_| |_____|
# |_____|                          |_____|                          

func Idle_state(_delta):
	pass

func Walk_state(_delta):
	if anim.frame == 3 or anim.frame == 4:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1

	if !ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1

	if player_detector.is_colliding():
		go_to_Attack_state()
		return

func Death_state(_delta):
	pass

func Attack_state(_delta):
	if anim.frame == 2 && can_throw: 
		throw_bone()
		can_throw = false

#     _    ____ ____ ___ ____ _____  _    _   _ _____ ____  
#    / \  / ___/ ___|_ _/ ___|_   _|/ \  | \ | |_   _/ ___| 
#   / _ \ \___ \___ \| |\___ \ | | / _ \ |  \| | | | \___ \ 
#  / ___ \ ___) |__) | | ___) || |/ ___ \| |\  | | |  ___) |
# /_/   \_\____/____/___|____/ |_/_/   \_\_| \_| |_| |____/ 

func take_damage():
	go_to_Death_state()

func throw_bone():
	var new_bone = SPINING_BONE.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_start_position.global_position
	new_bone.set_direction(self.direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "Attack":
		go_to_Walk_state()
		return
