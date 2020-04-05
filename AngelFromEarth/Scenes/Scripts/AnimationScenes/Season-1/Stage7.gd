extends Node2D

const NEXT_STAGE: String = "res://Scenes/SceneList/Season-1 Stages/Stage8-AnimatedScene.tscn"
onready var objective = $"Player/CanvasLayer/StoryAndObjectivePopup"

func _get_next_scene() -> String:
	$Player.update_high_score()
	return NEXT_STAGE
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._stop_all_musics()
	Music._play_music("dnb")
	objective._update_button_text("Close")
	objective._toggle_popup(true, true)
	if(get_tree().paused):
		$Player/informationLayer/InfoNode.visible = false
	$Player/informationLayer/InfoNode._update_survival_time("No Time Limit", 0, false)
	objective._update_label("Brave girl: Seems something big happening in the jungle, Find another portals to go more deeper!!!'")

func get_camera_limits():
	var bottom_camera_limit = 1100
	var right_camera_limit = 9500
	return [bottom_camera_limit, right_camera_limit]
