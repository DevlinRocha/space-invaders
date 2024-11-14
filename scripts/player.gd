class_name Player
extends CharacterBody2D


@onready var rocket_launcher: Node2D = $"Rocket Launcher"


const SPEED := 320.0


signal hit


func _ready() -> void:
	hit.connect(_on_hit)


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var shooting := Input.is_action_pressed("shoot")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if shooting:
		rocket_launcher.fire()

	move_and_slide()


func _on_hit() -> void:
	queue_free()
	explode()


func explode() -> void:
	const EXPLOSION := preload("res://effects/explosion.tscn")
	var new_explosion := EXPLOSION.instantiate()
	new_explosion.explode(self)
