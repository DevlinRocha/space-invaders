extends Node


@onready var pause_menu: ColorRect = %PauseMenu


func _ready() -> void:
	if not pause_menu.game_restart.is_connected(restart):
		pause_menu.game_restart.connect(restart)
	restart()


func _on_enemy_hit() -> void:
	#TODO: increment score on enemy hit
	print("hit enemy")


func restart() -> void:
	#TODO: implement restart functionality
	print("restart")
