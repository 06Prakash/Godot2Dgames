extends Button

export (String) var scene_to_load

func _on_RestartButton_pressed() -> void:
	var currentScene = get_tree().get_current_scene().get_filename()
	_remove_paused_state()
	var status = get_tree().change_scene(currentScene)

func _on_ExitButton_pressed() -> void:
	var parent = get_parent()
	_remove_paused_state()
	while(parent.name != "Player"):
		parent = parent.get_parent()
		if(parent.name == "Player"):
			parent.get_node("informationLayer/InfoNode").transition_to_next_stage(scene_to_load)
			break;
		if(parent.name == "TitleScreen"):
			parent.get_node("FadeIn").show()
			parent.get_node("FadeIn").fade_in()
			get_tree().change_scene(scene_to_load)
			break;

func _remove_paused_state():
	if get_tree().paused:
		get_tree().paused = not get_tree().paused

func _toggle_popup_state():
	_remove_paused_state()
	var parent = get_tree().get_nodes_in_group("Hero")[0]
	parent.get_node("CanvasLayer/PopupMenuControl")._toggle_popup()


func _on_Save_Button_pressed() -> void:
	print("Saving Game...")
	SaveSystem.save_game()
	print("Completed Save game!!")


func _on_ContinueButton_pressed() -> void:
	SaveSystem.load_game()


func _on_Resume_pressed() -> void:
	_toggle_popup_state()


func _on_NextButtonPopup_pressed() -> void:
	var parent = get_parent()
	while(parent.name != "Prelude"):
		parent = parent.get_parent()
		if("Stage" in parent.name):
			return
		if(parent.name == "Prelude"):
			parent.get_node(".")._move_to_next_script()


