extends Node


@onready var pause_menu: ColorRect = %PauseMenu
@onready var score: Label = %Score
@onready var high_score: Label = %HighScore
@onready var pause_score: Label = %PauseScore
@onready var pause_high_score: Label = %PauseHighScore


func _ready() -> void:
	if not pause_menu.game_restart.is_connected(restart):
		pause_menu.game_restart.connect(restart)
	restart()


func _on_enemy_hit() -> void:
	#TODO: increment score on enemy hit
	print("hit enemy")


func restart() -> void:
	for child in get_children():
		if child is Player or child is Enemy or child is Rocket or child is Bomb:
			child.queue_free()

	score.text = "0"
	pause_score.text = "0"

	const PLAYER := preload("res://scenes/player.tscn")
	var new_player := PLAYER.instantiate()
	new_player.global_position = Vector2(576, 544)
	add_child(new_player)

	const ENEMY := preload("res://scenes/enemy.tscn")
	for i in 11:
		var new_enemy := ENEMY.instantiate()
		var x := 96 * (i + 1)
		var y := 56
		new_enemy.global_position = Vector2(x, y)
		add_child(new_enemy)

	pause_menu.visible = false
	get_tree().paused = false
