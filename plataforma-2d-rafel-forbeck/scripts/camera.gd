extends Camera2D

var target: Node2D = null # Começa explicitamente como nulo

func _ready() -> void:
	get_target()

func _physics_process(_delta: float) -> void:
	# TRAVA DE SEGURANÇA: Só move a câmera se o target existir de verdade!
	if target and is_instance_valid(target):
		global_position = target.global_position
	else:
		# Se perdeu o player (ou ele não carregou a tempo), continua tentando buscar
		get_target()

func get_target() -> void:
	var nodes = get_tree().get_nodes_in_group("Player")
	
	# Se o array estiver vazio, sai da função sem quebrar o jogo
	if nodes.size() == 0:
		return
		
	# Se achou, define o target
	target = nodes[0]
