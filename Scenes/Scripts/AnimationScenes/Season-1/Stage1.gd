extends Node2D

onready var Info_layer
onready var objective = $"Player/CanvasLayer/StoryAndObjectivePopup"
var start_game = false
var portal_time_started = false
var enemiesPortal
var portal_duration
var summon_time = 2
const NEXT_STAGE: String = "res://Scenes/SceneList/Season-1 Stages/AnimatedStage2.tscn"

func _get_next_scene() -> String:
	$Player.update_high_score()
	return NEXT_STAGE

func get_camera_limits():
	var bottom_camera_limit = 1100
	var right_camera_limit = 3400
	return [bottom_camera_limit, right_camera_limit]
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._play_music("dnb")
	portal_duration = 120
	Info_layer = get_node("Player/informationLayer/InfoNode")
	objective._update_button_text("Close")
	objective._toggle_popup(true, true)
	if(get_tree().paused):
		$Player/informationLayer/InfoNode.visible = false
	objective._update_label("The Portal that spawns these zombies won't stay forever, Fight and survive until it explodes'")
	$ScriptTimer.start(5)
	enemiesPortal = get_tree().get_nodes_in_group("EnemyPortals")
	
func _process(delta: float) -> void:
	if(Info_layer.is_survival_timer_stopped()):
		get_node("Player")._set_is_stage_completed(true)
		$"Player/CanvasLayer/PopupMenuControl"._open_popup("YOU WON!!", $Player.current_player)

func _on_ScriptTimer_timeout() -> void:
	try_start_game()


func try_start_game():
	objective._toggle_popup(false)
	$Player/informationLayer/InfoNode.visible = true
	start_game = true
	for node in enemiesPortal:
		node.set_start_time(portal_duration)
		node.set_summon_timer(summon_time)
		node.start_timer()
	if !portal_time_started:
		Info_layer._update_survival_time("Portal Destruction Time: ", portal_duration)
		portal_time_started = true
