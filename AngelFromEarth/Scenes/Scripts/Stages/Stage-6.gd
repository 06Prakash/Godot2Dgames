extends Node2D

const NEXT_STAGE: String = "res://Scenes/SceneList/Season-1 Stages/Stage7.tscn"
onready var objective = $"Player/CanvasLayer/StoryAndObjectivePopup"


func _get_next_scene() -> String:
	$Player.update_high_score()
	return NEXT_STAGE

func get_camera_limits():
	var bottom_camera_limit = 900
	var right_camera_limit = 9600
	return [bottom_camera_limit, right_camera_limit]

func _ready() -> void:
	Music._stop_all_musics()
	Music._play_music("dnb")
	$"Portal".visible = true
	$"Portal".play("Idle")
	objective._update_button_text("Close")
	objective._toggle_popup(true, true)
	if(get_tree().paused):
		$Player/informationLayer/InfoNode.visible = false
	$Player/informationLayer/InfoNode._update_survival_time("No Time Limit", 0, false)
	objective._update_label("Investigate the Jungle, regarding this Giant spider's story !!!'")


func _on_Area2D_body_entered(body: KinematicBody2D) -> void:
	if body == null:
		return
	elif body.name != "Player":
		return
	$Player/BraveGirl.play("Idle")
	$Player.set_physics_process(false)
	$AnimationPlayer.play("BraveGirlAnimation")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if(anim_name == "BraveGirlAnimation"):
		$Player._set_is_stage_completed(true)
		$"Player/CanvasLayer/PopupMenuControl"._open_popup("YOU WON!!", $Player.current_player)
		
