extends Area2D


signal game_over


func _ready() -> void:
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_area_exited(area: Area2D) -> void:
	area.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		game_over.emit()
