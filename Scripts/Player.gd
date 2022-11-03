extends KinematicBody2D


var SPEED = 15
var max_sanity = Vector2(2, 2)
var min_sanity = Vector2(0.5, 0.5)
var velocity = Vector2.ZERO
var modified_light_scale 	
var moving_dir = "DOWN"
var is_attacking = false
var state_machine
onready var start_time = OS.get_ticks_msec()

signal attacked
signal dead


func _ready():
	state_machine = $AnimationTree.get("parameters/playback") 

	

func _physics_process(delta):
	Globals.elapsed_time = (OS.get_ticks_msec() - start_time)/1000
	handle_inputs()
	flicker_lights()
	check_dead()
	
	
	velocity = move_and_slide(velocity)
	
func check_dead():
	if $Light2D.scale < min_sanity:
		killPlayer()		
	
#		get_tree().change_scene("res://Scenes/DeadScreen.tscn")
		
func killPlayer():
	emit_signal("dead")
	

func flicker_lights():
	$flicker_tween.interpolate_property($Light2D, "texture_scale", 0.1, 0.3, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$flicker_tween.start()
	
func handle_inputs():
	
	var current = state_machine.get_current_node()
	
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		$attack.play()
		var a = $Sword.get_overlapping_bodies()
		if not a.empty():
			if a[0].get_class() == "KinematicBody2D":
				emit_signal("attacked", a[0].name)
		if moving_dir == "UP":
			state_machine.travel("attack_up")
			return
		if moving_dir == "DOWN":
			state_machine.travel("attack_down")
			return
		
	

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		moving_dir = "UP"
		$Sword.rotation_degrees = 0
		$Sword.position = Vector2(0, -4)
		
		
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		moving_dir = "DOWN"
		$Sword.rotation_degrees = 0
		$Sword.position = Vector2(0, 8)
	
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$Sprite.scale.x = 1
		$Sword.rotation_degrees = 90
		$Sword.position = Vector2(-6, 2)
	
			
		
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$Sprite.scale.x = -1
		$Sword.rotation_degrees = 90
		$Sword.position = Vector2(6, 2)

	velocity = velocity * SPEED 
	
	if velocity.length() == 0:
		if moving_dir == "UP":
			state_machine.travel("up_idle")
		if moving_dir == "DOWN":
			state_machine.travel("idle")

	if velocity.y < 0 :
		state_machine.travel("walk_up")
	if velocity.y > 0 :
		state_machine.travel("walk_anim")
	if velocity.x > 0 or velocity.x < 0:
		if moving_dir == "UP":
			state_machine.travel("walk_up")
		if moving_dir == "DOWN":
			state_machine.travel("walk_anim")

	
func gain_sanity():
	$gain_sanity.play()
	if $Light2D.scale < max_sanity:
		modified_light_scale = $Light2D.scale + Vector2(0.5, 0.5)
		$sanity_tween.interpolate_property($Light2D,"scale", null, modified_light_scale, .3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$sanity_tween.start()
	else:
		$Light2D.scale = max_sanity

func lose_sanity():
	$hurt.play()
	$AnimationPlayer.play("hurt")
	modified_light_scale = $Light2D.scale - Vector2(0.5, 0.5)
	$sanity_tween.interpolate_property($Light2D,"scale", null, modified_light_scale, .3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$sanity_tween.start()
	
func impact(direction):

	if direction == "RIGHT":
		var modified_pos = global_position + Vector2(10, 0)
		$knockback_tween.interpolate_property(self, 'position', global_position, modified_pos , 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$knockback_tween.start()
		return

	if direction == "LEFT":
		var modified_pos = global_position + Vector2(-10, 0)
		$knockback_tween.interpolate_property(self, 'position', global_position, modified_pos, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$knockback_tween.start()
		return

	if direction == "DOWN":
		var modified_pos = global_position + Vector2(0, 10)
		$knockback_tween.interpolate_property(self, 'position', global_position, modified_pos, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$knockback_tween.start()
		return

	if direction == "UP":
		var modified_pos = global_position + Vector2(0, -10)
		$knockback_tween.interpolate_property(self, 'position', global_position, modified_pos, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$knockback_tween.start()
		return

