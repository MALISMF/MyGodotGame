extends Button

# Загружаем сцену с панелью
var panel_scene = preload("res://PanelScene.tscn")
var panel_instance = null


func _pressed():
	print("button pressed")
	
	if panel_instance == null:
		# Создаем экземпляр сцены с панелью
		panel_instance = panel_scene.instantiate()
		# Добавляем в текущую сцену
		get_tree().current_scene.get_node("MainInterface").add_child(panel_instance)
		panel_instance.layer = 0
	else:
		# Переключаем видимость
		panel_instance.visible = !panel_instance.visible
