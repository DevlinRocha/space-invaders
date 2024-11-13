extends ColorRect


@onready var menu_label: Label = %MenuLabel
@onready var score: Label = %Score
@onready var high_score: Label = %HighScore
@onready var restart: Button = %Restart
@onready var quit: Button = %Quit


var is_game_over := false


signal game_restart


func _ready() -> void:
	if not restart.pressed.is_connected(_on_restart_pressed):
		restart.pressed.connect(_on_restart_pressed)
	if not quit.pressed.is_connected(_on_quit_pressed):
		quit.pressed.connect(_on_quit_pressed)


func _input(event: InputEvent) -> void:
	if not is_game_over and event.is_action_pressed("pause"):
		menu_label.text = "Game Paused"
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_restart_pressed() -> void:
	is_game_over = false
	game_restart.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func set_score(value: int) -> void:
	var current_score := value
	var new_score := str(current_score)
	score.text = new_score
	if current_score > int(high_score.text):
		high_score.text = new_score


func game_over() -> void:
	is_game_over = true
	menu_label.text = "Game Over"
