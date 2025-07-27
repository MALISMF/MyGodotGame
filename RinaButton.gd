extends Button

func _pressed():
	var scene = load("res://rina_scene.tscn")
	var main_character = get_tree().current_scene.get_node("MainCharacter")
	
	# Мгновенно удаляем всех детей
	for child in main_character.get_children():
		main_character.remove_child(child)
		child.queue_free()
	
	# Добавляем новых детей отложенно
	call_deferred("add_new_children", scene, main_character)

func add_new_children(scene, main_character):
	var instance = scene.instantiate()
	
	for child in instance.get_children():
		var duplicated_child = child.duplicate(7)
		main_character.add_child(duplicated_child)
	
	# Удаляем временный экземпляр
	instance.queue_free()
