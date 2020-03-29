extends Node2D

onready var scenepath = "res://Scenes/SceneList/TestLevelScenes/Prelude.tscn"


func _on_PlayOrResume_pressed() -> void:
	get_tree().current_scene.queue_free()
	get_tree().change_scene(scenepath)
