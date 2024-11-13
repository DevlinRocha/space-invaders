class_name Rocket
extends Area2D


const SPEED := 8


signal enemy_hit


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.queue_free()
		queue_free()
		enemy_hit.emit()


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()


func _physics_process(delta: float) -> void:
	global_position += Vector2(0, -SPEED)
