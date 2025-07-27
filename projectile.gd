extends Node2D

var speed = 400.0
var direction = Vector2.RIGHT

func _ready():
	# Удаляем снаряд через 5 секунд
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	# Движение снаряда
	position += direction * speed * delta

func _on_timeout():
	queue_free()
