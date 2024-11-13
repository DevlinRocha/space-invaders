extends Area2D


func _ready() -> void:
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)


func _on_area_exited(area: Area2D) -> void:
	area.queue_free()
