extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"ExitTimer".start(2)


func _on_ExitTimer_timeout() -> void:
	get_tree().quit()
