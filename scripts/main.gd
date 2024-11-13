extends Node


@onready var life_counter: HBoxContainer = %LifeCounter
@onready var score: Label = %Score
@onready var high_score: Label = %HighScore
@onready var menu: ColorRect = %Menu
@onready var menu_score: Label = %MenuScore
@onready var menu_high_score: Label = %MenuHighScore


var current_score: int : set = set_score
var current_level := 1


func _ready() -> void:
	if not menu.game_restart.is_connected(restart):
		menu.game_restart.connect(restart)
	restart()


func _on_enemy_hit() -> void:
	set_score(current_score + 1)

	for child in get_children():
		if child.is_in_group("enemies"):
			return
	current_level += 1
	get_tree().create_timer(3).timeout.connect(new_level.bind(current_level))


func _on_player_hit() -> void:
	if life_counter.get_child_count() <= 0:
		return game_over()

	life_counter.get_child(0).queue_free()
	get_tree().create_timer(3).timeout.connect(
		func() -> void:
			clear_level()
			respawn_player()
	)


func respawn_player() -> void:
	const PLAYER := preload("res://scenes/player.tscn")
	var new_player := PLAYER.instantiate()
	new_player.global_position = Vector2(576, 544)
	new_player.player_hit.connect(_on_player_hit)
	add_child(new_player)


func set_score(value: int) -> void:
	current_score = value
	var new_score := str(current_score)
	score.text = new_score
	if current_score > int(high_score.text):
		high_score.text = new_score
	menu.set_score(current_score)


func new_level(rows = 1) -> void:
	const ENEMY := preload("res://scenes/enemy.tscn")
	for i in rows:
		var y = 56 + 72 * i
		for j in 11:
			var new_enemy := ENEMY.instantiate()
			var x := 96 * (j + 1)
			new_enemy.global_position = Vector2(x, y)
			new_enemy.enemy_hit.connect(_on_enemy_hit)
			add_child(new_enemy)


func game_over() -> void:
	get_tree().paused = true
	menu.visible = true
	menu.game_over()


func restart() -> void:
	current_level = 1
	set_score(0)

	for child in get_children():
		if child is Player or child is Enemy or child is Rocket or child is Bomb:
			child.queue_free()

	respawn_player()

	new_level(current_level)

	menu.visible = false
	get_tree().paused = false


func clear_level() -> void:
	for child in get_children():
		if child.is_in_group("projectiles"):
			child.queue_free()
