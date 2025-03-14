extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		get_tree().call_deferred("reload_current_scene")
