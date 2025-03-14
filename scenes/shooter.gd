extends Node2D


@export var arrow_scene: PackedScene
@export var shoot_direction: Vector2 = Vector2.LEFT
@export var shoot_speed: float = 1000
@export var shoot_interval: float = 3.0

func _ready():
	$Timer.wait_time = shoot_interval
	$Timer.start()

func _on_timer_timeout():
	var arrow = arrow_scene.instantiate() as RigidBody2D
	arrow.global_position = global_position
	arrow.linear_velocity = shoot_direction * shoot_speed
	$AudioStreamPlayer2D.play()
	get_parent().add_child(arrow)
