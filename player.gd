extends CharacterBody2D

# Компоненты персонажа
@onready var movement = $PlayerMovement
@onready var shooting = $PlayerShooting

func _ready():
	# Дополнительная инициализация если нужна
	pass

# Методы для получения информации о персонаже
func get_last_direction() -> String:
	return movement.get_last_direction()

func is_flying() -> bool:
	return movement.is_flying()

func get_movement_component() -> PlayerMovement:
	return movement

func get_shooting_component() -> PlayerShooting:
	return shooting
