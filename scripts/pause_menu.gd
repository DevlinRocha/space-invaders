extends ColorRect


@onready var restart: Button = %Restart
@onready var quit: Button = %Quit


signal game_restart


func _ready() -> void:
	if not restart.pressed.is_connected(_on_restart_pressed):
		restart.pressed.connect(_on_restart_pressed)
	if not quit.pressed.is_connected(_on_quit_pressed):
		quit.pressed.connect(_on_quit_pressed)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_restart_pressed() -> void:
	game_restart.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
