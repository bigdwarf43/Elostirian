extends Control



var dialog = ["[center]Shrouded in darkness, you embrace the madness[/center]"]

var dialog_index = 0
var finished = false

signal dialog_complete

func _ready():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("fade_in")
	load_dialog()
	
func _process(delta):
	$Label.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("fade_out")
		
	
func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 2, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		emit_signal("dialog_complete")
		queue_free()
	dialog_index += 1
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://Scenes/DeadScreen.tscn")


func _on_Tween_tween_completed(object, key):
	finished = true
