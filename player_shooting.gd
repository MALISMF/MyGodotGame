extends Node
class_name PlayerShooting

@export var projectile_scene: PackedScene
@export var shoot_cooldown: float = 1
@export var projectile_speed: float = 400.0

var player: CharacterBody2D
var movement_component: PlayerMovement
var can_shoot = true
var current_direction = Vector2.DOWN

func _ready():
	player = get_parent() as CharacterBody2D
	movement_component = player.get_node("PlayerMovement")
	
	# Подключаемся к сигналу смены направления
	movement_component.direction_changed.connect(_on_direction_changed)
	
	# Загружаем снаряд если не назначен
	if not projectile_scene:
		projectile_scene = preload("res://projectile.tscn")

func _physics_process(delta):
	handle_shooting()

func handle_shooting():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	var player_pos = player.global_position
	var camera = get_viewport().get_camera_2d()
	var world_mouse_pos = camera.get_global_mouse_position()
	var direction = (world_mouse_pos - player_pos).normalized()
	
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	projectile.speed = projectile_speed
	projectile.global_position = player_pos
	projectile.rotation = direction.angle()
	
	get_tree().current_scene.add_child(projectile)
	start_cooldown()

func start_cooldown():
	can_shoot = false
	var timer = Timer.new()
	timer.wait_time = shoot_cooldown
	timer.one_shot = true
	timer.timeout.connect(func(): can_shoot = true)
	add_child(timer)
	timer.start()

func _on_direction_changed(direction: String):
	# Обновляем направление стрельбы при смене направления движения
	match direction:
		"up": current_direction = Vector2.UP
		"down": current_direction = Vector2.DOWN
		"left": current_direction = Vector2.LEFT
		"right": current_direction = Vector2.RIGHT

func get_projectile_spawn_position(projectile) -> Vector2:
	match current_direction:
		Vector2.UP:
			projectile.z_index = -1
			return player.get_node("ShootUp").global_position
		Vector2.DOWN:
			return player.get_node("ShootDown").global_position
		Vector2.LEFT:
			return player.get_node("ShootLeft").global_position
		Vector2.RIGHT:
			return player.get_node("ShootRight").global_position
		_:
			return player.global_position  # fallback
