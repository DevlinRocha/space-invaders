extends Node2D


@onready var fire_rate: Timer = $"Fire Rate"


const BOMB := preload("res://scenes/bomb.tscn")


var can_shoot := true


func _ready() -> void:
	if not fire_rate.timeout.is_connected(_on_fire_rate_timeout):
		fire_rate.timeout.connect(_on_fire_rate_timeout)


func fire() -> void:
	if not can_shoot:
		return

	var launch_failure := randi_range(0, 256)
	if launch_failure <= 255:
		return

	var new_bomb := BOMB.instantiate()
	new_bomb.global_position = global_position
	get_parent().add_sibling(new_bomb)
	can_shoot = false

	fire_rate.start()


func _on_fire_rate_timeout() -> void:
	can_shoot = true
