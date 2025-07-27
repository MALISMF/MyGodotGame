extends Node2D

func _ready():
	var scene = load("res://marina_scene.tscn")
	
	var instance = scene.instantiate()
	var instance_children = instance.get_children()
	
	for child in instance_children:
		var duplicated_child = child.duplicate()
		get_tree().current_scene.get_node("MainCharacter").add_child(duplicated_child)
