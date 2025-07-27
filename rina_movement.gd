extends Node
class_name RinaMovement
@export var speed: float = 100.0
var player: CharacterBody2D
var animated_sprite: AnimatedSprite2D
var last_direction = "down"
var last_standing_direction = "down"  # Направление для анимации покоя
var was_moving = false
var last_input_direction = Vector2.ZERO
var was_moving_prev = false
signal direction_changed(direction: String)

func _ready():
	player = get_parent() as CharacterBody2D
	animated_sprite = player.get_node("AnimatedSprite2D")

func _physics_process(delta):
	handle_movement(delta)
	handle_animations()


func handle_movement(delta):
	# Получаем направление движения
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.velocity = direction * speed
	
	# Обновляем направление только если есть значимое движение
	var is_moving = direction.length() > 0.1
	if is_moving:
		update_direction(direction)
		was_moving = true
	else:
		was_moving = false
	player.move_and_slide()
	was_moving_prev = was_moving

func update_direction(direction: Vector2):
	var old_direction = last_direction
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)
	# Определяем направление на основе наибольшего компонента
	if abs(abs_x - abs_y) < 0.3:
		if direction.x > 0 and direction.y < 0:
			last_direction = "right-up"
		elif direction.x < 0 and direction.y < 0:
			last_direction = "left-up"
		elif direction.x > 0 and direction.y > 0:
			last_direction = "right-down"
		elif direction.x < 0 and direction.y > 0:
			last_direction = "left-down"
	else:
		if abs_x > abs_y:
			if direction.x > 0:
				last_direction = "right"
			else:
				last_direction = "left"
		else:
			if direction.y > 0:
				last_direction = "down"
			else:
				last_direction = "up"
	# last_standing_direction всегда равен last_direction
	last_standing_direction = last_direction
	if old_direction != last_direction:
		direction_changed.emit(last_direction)

func handle_animations():
	if was_moving:
		# Движение - выбираем анимацию в зависимости от направления
		match last_direction:
			"right-down":
				animated_sprite.play("side-front-walking")
				animated_sprite.flip_h = false
			"left-down":
				animated_sprite.play("side-front-walking")
				animated_sprite.flip_h = true
			"right-up":
				animated_sprite.play("side-back-walking")
				animated_sprite.flip_h = false
			"left-up":
				animated_sprite.play("side-back-walking")
				animated_sprite.flip_h = true
			"left":
				animated_sprite.play("side-walking")
				animated_sprite.flip_h = true
			"right":
				animated_sprite.play("side-walking")
				animated_sprite.flip_h = false
			"down":
				animated_sprite.play("walking")
				animated_sprite.flip_h = false
			"up":
				animated_sprite.play("back-walking")
				animated_sprite.flip_h = false
	else:
		# Стояние на месте - используем last_standing_direction
		match last_standing_direction:
			"right":
				animated_sprite.play("side-standing")
				animated_sprite.flip_h = false
			"left":
				animated_sprite.play("side-standing")
				animated_sprite.flip_h = true
			"right-up":
				animated_sprite.play("side-back-standing")
				animated_sprite.flip_h = false
			"left-up":
				animated_sprite.play("side-back-standing")
				animated_sprite.flip_h = true
			"left-down":
				animated_sprite.play("side-front-standing")
				animated_sprite.flip_h = true
			"right-down":
				animated_sprite.play("side-front-standing")
				animated_sprite.flip_h = false
			"up":
				animated_sprite.play("back-standing")
				animated_sprite.flip_h = false
			"down":
				animated_sprite.play("standing")
				animated_sprite.flip_h = false

func get_last_direction() -> String:
	return last_direction

func get_direction_vector() -> Vector2:
	match last_direction:
		"right": return Vector2.RIGHT
		"left": return Vector2.LEFT
		"up": return Vector2.UP
		"down": return Vector2.DOWN
		"right-up", "left-up": return Vector2.UP
		"right-down", "left-down": return Vector2.DOWN
		_: return Vector2.DOWN


func _is_direction_switch_needs_delay(prev: Vector2, curr: Vector2) -> bool:
	# Было диагональное, стало не-диагональное или наоборот
	return _is_diagonal(prev) != _is_diagonal(curr) and curr.length() > 0.1

func _is_diagonal(dir: Vector2) -> bool:
	return abs(abs(dir.x) - abs(dir.y)) < 0.3 and dir.length() > 0.1

func _get_direction_name(direction: Vector2) -> String:
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)
	if abs(abs_x - abs_y) < 0.3:
		if direction.x > 0 and direction.y < 0:
			return "right-up"
		elif direction.x < 0 and direction.y < 0:
			return "left-up"
		elif direction.x > 0 and direction.y > 0:
			return "right-down"
		elif direction.x < 0 and direction.y > 0:
			return "left-down"
	else:
		if abs_x > abs_y:
			if direction.x > 0:
				return "right"
			else:
				return "left"
		else:
			if direction.y > 0:
				return "down"
			else:
				return "up"
	return "down"
