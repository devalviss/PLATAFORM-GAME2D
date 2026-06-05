extends CharacterBody2D

enum SkeletonState{
	walk,
	death
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var status: SkeletonState

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.death:
			death_state(delta)

	move_and_slide()

#   ____  ___   _____ ___    _________  _____ _____   _____ ____   ___  __  __ 
#  / ___|/ _ \ |_   _/ _ \  / / ____\ \/ /_ _|_   _| |  ___|  _ \ / _ \|  \/  |
# | |  _| | | |  | || | | |/ /|  _|  \  / | |  | |   | |_  | |_) | | | | |\/| |
# | |_| | |_| |  | || |_| / / | |___ /  \ | |  | |   |  _| |  _ <| |_| | |  | |
#  \____|\___/___|_| \___/_/  |_____/_/\_\___| |_|___|_|   |_| \_\\___/|_|  |_|
#           |_____|                             |_____|                        

	
func go_to_walk_state():
		status = SkeletonState.walk
		anim.play("walk")
func go_to_death_state():
		status = SkeletonState.death
		anim.play("death")
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		
#      ____ _____  _  _____ _____     ____ _____  _  _____ _____ 
#     / ___|_   _|/ \|_   _| ____|   / ___|_   _|/ \|_   _| ____|
#     \___ \ | | / _ \ | | |  _|     \___ \ | | / _ \ | | |  _|  
#      ___) || |/ ___ \| | | |___     ___) || |/ ___ \| | | |___ 
# ____|____/ |_/_/   \_\_| |_____|___|____/ |_/_/   \_\_| |_____|
#|_____|                        |_____|                              
				   

func walk_state(_dealta):
		pass

func death_state(_dealta):
		pass

func take_damage():
	go_to_death_state()
