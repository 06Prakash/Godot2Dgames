extends Node2D

onready var scoreText = $"Score Board"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_score_Text(score: int):
	scoreText.text = "Score : " + str(score)
