extends Area2D

@export var sceneName: String = "Level2"

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		print("Reached objective!")
		body.show_win()
		$AudioStreamPlayer.play()
		$Timer.start()
		

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
