extends Node2D

onready var current_game_status = $"CurrentGameStatus"

var red_color = Color.red
var green_color = Color.green
var blue_color = Color.blue
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_game_status.text =  "In Progress"

func _set_game_current_game_status(status: String):
	current_game_status.text = status

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
