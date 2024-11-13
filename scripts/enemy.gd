class_name Enemy
extends CharacterBody2D


@onready var bomb_launcher: Node2D = $BombLauncher
@onready var left_ray_cast: RayCast2D = $LeftRayCast
@onready var right_ray_cast: RayCast2D = $RightRayCast


const HORIZONTAL_SPEED := 1
const VERTICAL_SPEED := 88


var direction := Direction.RIGHT


enum Direction { LEFT, RIGHT }


func _physics_process(delta: float) -> void:
	if right_ray_cast.is_colliding():
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position + Vector2(0, VERTICAL_SPEED), 1)
		direction = Direction.LEFT
		pass
	if left_ray_cast.is_colliding():
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position + Vector2(0, VERTICAL_SPEED), 1)
		direction = Direction.RIGHT
		pass

	bomb_launcher.fire()
	move()


func move() -> void:
	if direction == Direction.LEFT:
		position = position + Vector2(-HORIZONTAL_SPEED, 0)
	if direction == Direction.RIGHT:
		position = position + Vector2(HORIZONTAL_SPEED, 0)