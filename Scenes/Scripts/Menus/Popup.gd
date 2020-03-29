extends Node2D

# Objective of the stage is provided using this popup at the start of the game

onready var textArea = $PopupPanel/VBoxContainer/Label
onready var button = $PopupPanel/VBoxContainer/CenterContainer/NextButtonPopup/Label

func _toggle_popup(open: bool, need_to_pause= false):
	if(open and not $PopupPanel.visible):
		_update_label("")
		if(need_to_pause):
			get_tree().paused = true
		$PopupPanel.visible = true
	else:
		$PopupPanel.visible = false
		get_tree().paused = false

func _update_label(text_to_update):
	textArea.text = text_to_update

func _update_button_text(button_text : String):
	button.text = button_text


func _on_NextButtonPopup_pressed() -> void:
	if(get_tree().get_nodes_in_group("prelude") == null):
		_toggle_popup(false)
