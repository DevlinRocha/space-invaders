class_name Enemy
extends CharacterBody2D


@onready var bomb_launcher: Node2D = $BombLauncher
@onready var ray_cast_2d: RayCast2D = $RayCast2D


const VERTICAL_SPEED := 72


var horizontal_speed := 1
var is_colliding := false

signal hit
signal defeated


func _ready() -> void:
	hit.connect(_on_hit)


func _physics_process(delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		bomb_launcher.fire()

	var collision := move_and_collide(Vector2(horizontal_speed, 0))
	if not collision:
		set_collision_mask_value(4, true)

	if collision:
		on_collide(collision.get_collider())


func _on_hit() -> void:
	queue_free()
	tree_exited.connect(
		func() -> void:
			defeated.emit()
	)


func on_collide(collider: Node) -> void:
	if is_colliding:
		return

	is_colliding = true

	if collider is StaticBody2D:
		for child in get_parent().get_children():
			if child.is_in_group("enemies"):
				child.set_collision_mask_value(4, false)
				var tween := create_tween()
				tween.tween_property(child, "global_position", child.global_position + Vector2(0, VERTICAL_SPEED), 1).finished.connect(
					func() -> void:
						child.horizontal_speed *= -1
						child.set_collision_mask_value(4, true)
						is_colliding = false
				)
	if collider is Player:
		hit.emit()
		collider.hit.emit()
