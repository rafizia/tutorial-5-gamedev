extends CharacterBody2D

@export var walk_speed = 200
@export var crouch_speed = 100
@export var gravity = 300.0
@export var jump_speed = -300
@export var dash_speed = 900

var double_jump = false
var dash = false
var can_dash = true
var last_left_move_time = 0
var last_right_move_time = 0
var is_dead = false
const dash_interval = 0.1
	
	
func _physics_process(delta):
	velocity.y += delta * gravity
	
	if !is_dead:
	
		if Input.is_action_just_pressed("ui_up"):
			if is_on_floor():
				velocity.y = jump_speed
				double_jump = true
			elif double_jump:
				velocity.y = jump_speed
				double_jump = false
				
		if Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.flip_h = true
			if Input.is_action_pressed("ui_down"):
				velocity.x = -crouch_speed
				$AnimatedSprite2D.play("crouch")
			else:
				$AnimatedSprite2D.play("walk right")	
				if Input.is_action_just_pressed("ui_left") and can_dash:
					if Time.get_ticks_msec() / 1000 - last_left_move_time < dash_interval:
						dash = true
						can_dash = false
						$DashTimer.start()
						$CanDashTimer.start()
					else:
						dash = false
					last_left_move_time = Time.get_ticks_msec() / 1000
				if dash:
					velocity.x = -dash_speed
				else:
					velocity.x = -walk_speed
				
		elif Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.flip_h = false
			if Input.is_action_pressed("ui_down"):
				velocity.x = crouch_speed
				$AnimatedSprite2D.play("crouch")
			else:
				velocity.x = walk_speed
				$AnimatedSprite2D.play("walk right")
				if Input.is_action_just_pressed("ui_right") and can_dash:
					if Time.get_ticks_msec() / 1000 - last_right_move_time < dash_interval:
						dash = true
						can_dash = false
						$DashTimer.start()
						$CanDashTimer.start()
					else:
						dash = false
					last_right_move_time = Time.get_ticks_msec() / 1000
				if dash:
					velocity.x = dash_speed
				else:
					velocity.x = walk_speed
				
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("crouch")
			
		else:
			velocity.x = 0
			$AnimatedSprite2D.play("idle")
			
		# "move_and_slide" already takes delta time into account.
	move_and_slide()
	

func _on_can_dash_timer_timeout() -> void:
	can_dash = true
	

func _on_dash_timer_timeout() -> void:
	dash = false
	
	
func show_win():
	$Camera2D/Win.visible = true
	
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
	
func dead():
	is_dead = true
	velocity.x = 0
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play("dead")
