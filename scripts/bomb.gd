class_name Bomb
extends Area2D


const SPEED := 2


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	body.queue_free()
	queue_free()


func _physics_process(delta: float) -> void:
	global_position += Vector2(0, SPEED)
