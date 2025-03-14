extends RigidBody2D


func _ready():
	gravity_scale = 0.0
	
func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		gravity_scale = 1.0
		await get_tree().create_timer(10).timeout
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		get_tree().call_deferred("reload_current_scene")
