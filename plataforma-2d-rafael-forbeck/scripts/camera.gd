extends Camera2D

var target: Node2D

func _ready() -> void:
	# Tenta pegar no início, se falhar, o _process cuida disso
	get_target()
	
func _process(_delta: float) -> void:
	# Se o target ainda não foi encontrado (devido ao tempo de carregamento), tenta de novo
	if not target:
		get_target()
		return # Sai do processo neste frame para não quebrar a linha abaixo
		
	# Se encontrou, segue a posição do Player perfeitamente
	position = target.position
	
func get_target() -> void:
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() > 0:
		target = nodes[0] as Node2D
