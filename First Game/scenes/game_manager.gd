extends Node

var score = 0

@onready var score_label = $ScoreLabel
func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."


func _on_level_1_body_entered(body):
	pass # Replace with function body.
