extends KinematicBody2D

var velocity = Vector2.ZERO
var SPEED = 4
var chase = "treasure"
signal treasureTouched

onready var playernode = get_tree().get_root().find_node("Player", true, false)
onready var sanitynode = preload("res://Scenes/sanityPickup.tscn")
onready var treasurenode = get_tree().get_root().find_node("Treasure", true, false)

func _ready():
	playernode.connect("attacked", self, "hit")
	
func _physics_process(delta):
	if chase == "treasure":

		velocity = position.direction_to(treasurenode.position) * SPEED
		if position.y > treasurenode.position.y:
			$AnimationPlayer.play("walk_up")
		else:
			$AnimationPlayer.play("walk_down")
			
		if position.x < treasurenode.position.x:
			$Sprite.scale.x = -1
		elif position.x > treasurenode.position.x:
			$Sprite.scale.x = 1
			
	if chase == "player":
		velocity = position.direction_to(playernode.position) * SPEED
		if position.y > playernode.position.y:
			$AnimationPlayer.play("walk_up")
		else:
			$AnimationPlayer.play("walk_down")
			
		if position.x < playernode.position.x:
			$Sprite.scale.x = -1
		elif position.x > playernode.position.x:
			$Sprite.scale.x = 1
			
		
	move_and_slide(velocity)

func hit(enemyNo):
	$hit.play()
	if enemyNo == self.name:
		randomize()
		var chance = int(rand_range(1, 4))
		if chance == 1:
			var s = sanitynode.instance()
			s.position = position	
			get_parent().add_child(s)
		queue_free()

func treasureTouched():
	playernode.killPlayer()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.lose_sanity()
		if $rayRIGHT.is_colliding():
			body.impact("RIGHT")
		if $rayLEFT.is_colliding():
			body.impact("LEFT")
		if $rayDOWN.is_colliding():
			body.impact("DOWN")
		if $rayUP.is_colliding():
			body.impact("UP")


func _on_ChaseArea_body_entered(body):
	if body.name == "Player":
		
		chase = "player"


func _on_ChaseArea_body_exited(body):
	if body.name == "Player":
		
		chase = "treasure"
