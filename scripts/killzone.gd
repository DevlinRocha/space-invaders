extends Area2D


func _ready() -> void:
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _on_body_exited(body: Node2D) -> void:
	body.queue_free()
