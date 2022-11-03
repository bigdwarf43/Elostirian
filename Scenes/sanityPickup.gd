extends Area2D

func _on_sanityPickup_body_entered(body):
	if body.has_method("gain_sanity"):
		body.gain_sanity()
		queue_free()
