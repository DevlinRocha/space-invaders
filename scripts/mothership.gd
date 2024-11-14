class_name Mothership
extends CharacterBody2D


const SPEED = 300.0


var horizontal_speed: int


signal hit
signal defeated


func _ready() -> void:
	if not hit.is_connected(_on_hit):
		hit.connect(_on_hit)

	get_tree().create_timer(16, false).timeout.connect(
		func() -> void:
			queue_free()
			defeated.emit(0)
	)

	var direction = randi_range(0, 1)
	match direction:
		0:
			global_position = Vector2(-96, 16)
			horizontal_speed = 2
		1:
			global_position = Vector2(1248, 16)
			horizontal_speed = -2


func _physics_process(delta: float) -> void:
	move_and_collide(Vector2(horizontal_speed, 0))


func _on_hit() -> void:
	queue_free()
	tree_exited.connect(
		func() -> void:
			defeated.emit(10)
	)
