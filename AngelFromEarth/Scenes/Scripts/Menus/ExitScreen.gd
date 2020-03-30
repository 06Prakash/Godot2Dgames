extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_nodes_in_group("exit_screen")[0].get_node("ExitTimer").start(2)

func _on_ExitTimer_timeout() -> void:
	get_tree().quit()
