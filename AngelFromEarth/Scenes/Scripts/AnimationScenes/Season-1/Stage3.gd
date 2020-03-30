extends Node2D

onready var Info_layer
onready var objective = $"Player/CanvasLayer/StoryAndObjectivePopup"
var start_game = false
var portal_time_started = false
var summon_time = 2
const NEXT_STAGE: String = "res://Scenes/SceneList/Season-1 Stages/AnimatedStage4.tscn"

func _get_next_scene() -> String:
	$Player.update_high_score()
	return NEXT_STAGE

func get_camera_limits():
	var bottom_camera_limit = 1100
	var right_camera_limit = 3400
	return [bottom_camera_limit, right_camera_limit]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._stop_all_musics()
	Music._play_music("dnb")
	Info_layer = get_node("Player/informationLayer/InfoNode")
	objective._update_button_text("Close")
	objective._toggle_popup(true, true)
	if(get_tree().paused):
		$Player/informationLayer/InfoNode.visible = false
	objective._update_label("Defeat the Giant Spider and investigate the reason for this attack!!!'")
	
func _process(delta: float) -> void:
	if(get_tree().paused):
		$Player/informationLayer/InfoNode.visible = false
	else:
		$Player/informationLayer/InfoNode.visible = true
	if(Info_layer.is_survival_timer_stopped() and $"GiantSpider" == null):
		get_tree().get_nodes_in_group("Hero")[0]._set_is_stage_completed(true)
		$"Player/CanvasLayer/PopupMenuControl"._open_popup("YOU WON!!")

func _on_ScriptTimer_timeout() -> void:
	try_start_game()


func _on_NextButtonPopup_pressed() -> void:
	try_start_game()

func try_start_game():
	objective._toggle_popup(false)
	$Player/informationLayer/InfoNode.visible = false
	start_game = true
	Info_layer._update_survival_time("No Time limit: ", 0)
	portal_time_started = true
