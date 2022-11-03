extends Control



func _on_Start_button_pressed():
	$optionAudio.play()
	$AnimationPlayer.play("fade_out")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Starting_message.tscn")


	
