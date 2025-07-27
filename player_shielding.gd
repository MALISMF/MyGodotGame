extends Node
func _physics_process(delta):
	handle_shielding()
	
	
func handle_shielding():
	if Input.is_action_just_pressed("shield"):
		shield()

func shield():
	get_parent().get_node("Shield").visible = !get_parent().get_node("Shield").visible
