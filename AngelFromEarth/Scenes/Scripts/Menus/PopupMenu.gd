extends Control

onready var agni_puthiran_node = $Popup/AgniPuthiran
onready var brave_girl = $Popup/BraveGirl
onready var background_details = $Popup/Background
## Popup that displayes the pause menu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_open_popup()

func update_highscore(score: int):
	background_details.update_hi_score(score)

func _open_popup(game_status = "In Progress", actor ="AgniPuthiran"):
	if(game_status != ""):
		$Popup/GameStatus._set_game_current_game_status(game_status)
	if(actor == "AgniPuthiran"):
		agni_puthiran_node.visible = true
	elif actor == "BraveGirl":
		brave_girl.visible = true
	if(not $Popup.visible):
		_toggle_popup()
		_toggle_pause()

func _toggle_popup():
	$Popup.visible = not $Popup.visible

func _toggle_pause():
	get_tree().paused = not get_tree().paused

func _ready() -> void:
	agni_puthiran_node.visible = false
	agni_puthiran_node._hide_pointer()
	brave_girl.visible = false
	brave_girl._hide_pointer()
	pass

func _on_NextStageButton_pressed() -> void:
	var current_stage_completed = get_tree().get_nodes_in_group("Hero")[0]._get_is_stage_completed()
	if(current_stage_completed):
		var scene_path = get_tree().get_nodes_in_group("stage")[0]._get_next_scene()
		get_tree().change_scene(scene_path)
		
