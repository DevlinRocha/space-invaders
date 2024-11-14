extends Node


@onready var life_counter: HBoxContainer = %LifeCounter
@onready var bottom_killzone: Area2D = %BottomKillzone
@onready var score: Label = %Score
@onready var high_score: Label = %HighScore
@onready var menu: ColorRect = %Menu
@onready var menu_score: Label = %MenuScore
@onready var menu_high_score: Label = %MenuHighScore


var current_score: int : set = set_score
var current_level := 1
var mothership_threshold := 16
var new_level_timer: SceneTreeTimer
var respawn_player_timer: SceneTreeTimer
var mothership_roll_timer: SceneTreeTimer


func _ready() -> void:
	if not bottom_killzone.game_over.is_connected(game_over):
		bottom_killzone.game_over.connect(game_over)
	if not menu.game_restart.is_connected(restart):
		menu.game_restart.connect(restart)
	restart()


func _on_enemy_defeated(points: int) -> void:
	set_score(current_score + points)

	for child in get_children():
		if child.is_in_group("enemies"):
			return

	current_level += 1
	mothership_threshold -= 1
	new_level_timer = get_tree().create_timer(3, false)
	new_level_timer.timeout.connect(new_level.bind(current_level))


func _on_player_hit() -> void:
	if life_counter.get_child_count() <= 0:
		return game_over()

	life_counter.get_child(0).queue_free()
	respawn_player_timer = get_tree().create_timer(3, false)
	respawn_player_timer.timeout.connect(respawn_player)


func respawn_player() -> void:
	clear_level()

	const PLAYER := preload("res://scenes/player.tscn")
	var new_player := PLAYER.instantiate()
	new_player.global_position = Vector2(576, 544)
	new_player.hit.connect(_on_player_hit)
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
	for row in rows:
		var y = 72 * (row + 1)
		for column in 11:
			var new_enemy := ENEMY.instantiate()
			var x := 96 * (column + 1)
			new_enemy.global_position = Vector2(x, y)
			new_enemy.defeated.connect(_on_enemy_defeated)
			add_child(new_enemy)


func game_over() -> void:
	get_tree().paused = true
	menu.visible = true
	menu.game_over()


func restart() -> void:
	if new_level_timer:
		new_level_timer.timeout.disconnect(new_level)
	if respawn_player_timer:
		respawn_player_timer.timeout.disconnect(respawn_player)
	if mothership_roll_timer:
		mothership_roll_timer.timeout.disconnect(roll_mothership)
	current_level = 1
	mothership_threshold = 16
	set_score(0)
	life_counter.reset()
	mothership_roll_timer = get_tree().create_timer(4, false)
	mothership_roll_timer.timeout.connect(roll_mothership)

	for child in get_children():
		if child is Player or child.is_in_group("enemies") or child.is_in_group("projectiles"):
			child.queue_free()

	respawn_player()

	new_level(current_level)

	menu.visible = false
	get_tree().paused = false


func clear_level() -> void:
	for child in get_children():
		if child.is_in_group("projectiles"):
			child.queue_free()


func roll_mothership() -> void:
	var roll := randi_range(0, mothership_threshold)
	if roll >= mothership_threshold - 1:
		const MOTHERSHIP := preload("res://scenes/mothership.tscn")
		var new_mothership := MOTHERSHIP.instantiate()
		new_mothership.defeated.connect(_on_enemy_defeated)
		add_child(new_mothership)
		mothership_roll_timer = get_tree().create_timer(16, false)
		mothership_roll_timer.timeout.connect(roll_mothership)
		return

	mothership_roll_timer = get_tree().create_timer(4, false)
	mothership_roll_timer.timeout.connect(roll_mothership)
