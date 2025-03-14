extends RigidBody2D


@export var speed: float = 300
@export var direction: Vector2 = Vector2.LEFT

func _physics_process(delta):
	linear_velocity = direction * speed

func _on_body_entered(body: Node):
	if body.get_name() == "Player":
		body.dead()
		$Timer.start()

func _on_timer_timeout() -> void:
	get_tree().call_deferred("reload_current_scene")
