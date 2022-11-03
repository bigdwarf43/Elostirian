extends Node2D

var Enemy
onready var playernode = get_tree().get_root().find_node("Player", true, false)


func _ready():
	$AnimationPlayer.play("fade_in")
	Enemy = preload("res://Scenes/Enemy.tscn")
	playernode.connect("dead", self, "notSane")
	$Timer.start()
	
func notSane():
	$AnimationPlayer.play("death")


func _on_Timer_timeout():
	randomize()
	var enemy_pos = Vector2(rand_range(-20, 80), rand_range(-20, 80))
	while enemy_pos.x > 0 and enemy_pos.x < 64 and enemy_pos.y > 0 and enemy_pos.y < 64:
		enemy_pos = Vector2(rand_range(-20, 80), rand_range(-20, 80))
	var e = Enemy.instance()
	e.position = enemy_pos
	add_child(e)
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().change_scene("res://Scenes/Ending_message.tscn")
