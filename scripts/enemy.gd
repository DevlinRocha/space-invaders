class_name Enemy
extends CharacterBody2D


@onready var bomb_launcher: Node2D = $BombLauncher
@onready var ray_cast_2d: RayCast2D = $RayCast2D


var horizontal_speed := 1.0
var vertical_speed := 0.0
var is_colliding := false

signal hit
signal defeated


func _ready() -> void:
	hit.connect(_on_hit)


func _physics_process(delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		bomb_launcher.fire()

	var collision := move_and_collide(Vector2(horizontal_speed, vertical_speed))

	if collision:
		on_collide(collision.get_collider())


func _on_hit() -> void:
	queue_free()
	tree_exited.connect(
		func() -> void:
			defeated.emit(1)
	)


func on_collide(collider: Node) -> void:
	if collider is StaticBody2D:
		if is_colliding:
			return

		for child in get_parent().get_children():
			if child is Enemy:
				var new_horizontal_speed = child.horizontal_speed * -1.0
				child.is_colliding = true
				child.set_collision_mask_value(4, false)
				child.horizontal_speed = 0.0
				child.vertical_speed = 1.0
				get_tree().create_timer(72.0 / 60.0, false).timeout.connect(
					func() -> void:
						if not child:
							return

						child.horizontal_speed = new_horizontal_speed
						child.vertical_speed = 0.0
						child.set_collision_mask_value(4, true)
						child.is_colliding = false
				)


	if collider is Player:
		hit.emit()
		collider.hit.emit()
