extends Area2D

signal player_detected(body)
signal player_lost(body)

func _on_body_entered(body):
	print("You died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()

func _on_detection_area_body_exited(body):
	if body.get_name() == "Player":
		emit_signal("player_lost", body)
		print("Player lost")
