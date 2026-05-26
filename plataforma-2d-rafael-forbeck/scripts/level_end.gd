extends Area2D

@export var next_level = ""

func _on_body_entered(_body: Node2D) -> void:
	print("You passed to the next level")
	call_deferred("load_next_scene")
	
func load_next_scene():
	# Adicionando a barra '/' após scene para que ele busque o nome direto que você digitar
	get_tree().change_scene_to_file("res://scene/" + next_level + ".tscn")
