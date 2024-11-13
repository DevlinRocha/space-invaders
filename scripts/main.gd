extends Node


@onready var pause_menu: ColorRect = %PauseMenu
@onready var score: Label = %Score
@onready var high_score: Label = %HighScore
@onready var pause_score: Label = %PauseScore
@onready var pause_high_score: Label = %PauseHighScore


var current_score: int : set = set_score


func _ready() -> void:
	if not pause_menu.game_restart.is_connected(restart):
		pause_menu.game_restart.connect(restart)
	restart()


func _on_enemy_hit() -> void:
	set_score(current_score + 1)

	for child in get_children():
		if child.is_in_group("enemies"):
			return
	new_level()


func set_score(value: int) -> void:
	current_score = value
	var new_score := str(current_score)
	score.text = new_score
	pause_score.text = new_score
	if current_score > int(high_score.text):
		high_score.text = new_score
		pause_high_score.text = new_score


func restart() -> void:
	set_score(0)

	for child in get_children():
		if child is Player or child is Enemy or child is Rocket or child is Bomb:
			child.queue_free()

	const PLAYER := preload("res://scenes/player.tscn")
	var new_player := PLAYER.instantiate()
	new_player.global_position = Vector2(576, 544)
	add_child(new_player)

	new_level()

	pause_menu.visible = false
	get_tree().paused = false


func new_level() -> void:
	const ENEMY := preload("res://scenes/enemy.tscn")
	for i in 11:
		var new_enemy := ENEMY.instantiate()
		var x := 96 * (i + 1)
		var y := 56
		new_enemy.global_position = Vector2(x, y)
		new_enemy.enemy_hit.connect(_on_enemy_hit)
		add_child(new_enemy)
