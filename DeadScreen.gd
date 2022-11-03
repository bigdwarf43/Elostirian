extends Control


var score = 0

func _ready():
	$AnimationPlayer.play("fade_in")
	score = Globals.elapsed_time
	$Label.text = "You spent "+str(score)+" seconds with your precious in flesh"
	

func _on_Try_again_pressed():
	$AudioStreamPlayer.play()
	$ColorRect2.visible = true
	$AnimationPlayer.play("fade_out")
	



func _on_quit_pressed():
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		$ColorRect2.visible = false
	if anim_name == "fade_out":
		get_tree().change_scene("res://Scenes/MainScene.tscn")
