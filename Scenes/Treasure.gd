extends StaticBody2D


func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.has_method("treasureTouched"):
		body.treasureTouched()
