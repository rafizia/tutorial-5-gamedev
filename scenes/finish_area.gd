extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.show_win()
		$AudioStreamPlayer.play()
		await get_tree().create_timer(5).timeout
		get_tree().call_deferred("reload_current_scene")
		
