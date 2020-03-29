extends Node2D

onready var conversation_layer = $"CanvasLayer/ColorRect/ConversationWindow"
onready var next_conversation = $"CanvasLayer/ColorRect/GoNextConversation"
onready var script_control = $ScriptController
var scripts = []
var current_script_count = -1
var total_scripts
var is_completed_conversation = false
var timeDuration
var current_speaker_node
onready var fade_in_layer = $CanvasLayer/FadeIn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_in_layer.show_behind_parent = true
	next_conversation.get_node("Label").text = ""

# Set the array of conversation that needs to happen
func set_conversation_script(obtained_scripts: Array):
	scripts = obtained_scripts
	total_scripts = scripts.size()

# sets the duration within which the transition from one to next script happens
func set_duration_between_scripts(time:int):
	timeDuration = time
	script_control.start(timeDuration)

func UpdateText(data : String):
	conversation_layer.text = ""
	conversation_layer.text = data

func _on_ScriptController_timeout() -> void:
	_go_to_next_script()

func _go_to_next_script():
	script_control.start(timeDuration)
	current_script_count += 1
	if(current_script_count < total_scripts):
		UpdateText(scripts[current_script_count])
		current_speaker_node = scripts[current_script_count].split(":")[0]
	else:
		is_completed_conversation = true

func get_is_completed_conversation() -> bool:
	return is_completed_conversation

func get_current_speaker_node() -> String:
	return current_speaker_node

func need_to_shake() -> bool:
	if("why the ground is shaking" in scripts[current_script_count]):
		return true
	return false

func show_fade_in():
	fade_in_layer.show_behind_parent = false
	fade_in_layer.show()
	fade_in_layer.fade_in()

func _on_FadeIn_fade_in_finished() -> void:
	var NEXT_STAGE = get_tree().get_nodes_in_group("stage")[0].NEXT_STAGE
	get_tree().change_scene(NEXT_STAGE)
	
func _on_GoNextConversation_pressed() -> void:
	_go_to_next_script()
