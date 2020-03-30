extends Node2D

onready var conversation_layer = $"ConversationLayer"
onready var agniputhiran_node = $"AgniPuthiran"
onready var agni_father_node = $"Agni's Father"
onready var bravegirl_node = $"BraveGirl"

const NEXT_STAGE : String= "res://Scenes/SceneList/Season-1 Stages/Stage6.tscn"
var scripts = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._stop_all_musics()
	scripts = [
		"BraveGirl: You defeated that spider?",
		"AgniPuthiran: Yup, I also got some lead, It seems their species are in danger and our enemy is same!!",
		"BraveGirl: So you let that giant spider go, just like that?",
		"Agni's Father: Agni's decision won't be wrong, I guess there is no need to kill without reason",
		"AgniPuthiran: Yes father, I had small conversation with that giant spider, and it is in need of our help to save its family",
		"Agni's Father: So you are planning to save them",
		"AgniPuthiran: Not only save them father, we may get the answer for these recent attacks on our village",
		"Agni's Father: I agree to your point!! Our builders won't be able to fix the gates if we are getting attacks frequently",
		"AgniPuthiran: Don't worry we are having a GIANT SUPPORT to handle them all",
		"Agni's Father: Wait, You mean that Giant Spider turns out to be our ally??!!",
		"AgniPuthiran: Exactly!! It is very powerful and that will be able to protect this village, until I am back from my investigation",
		"BraveGirl: I can also help you out in this investigation on that forest, Please let me check it first",
		"AgniPuthiran: Ok, You are good at stealth right, I guess it is a good idea for you to go and check what is happening over there",
		"BraveGirl: I am starting immediately!!",
		"Agni's Father: Please stay alert enemies as well as animals both are dangerous, if you stomp on them they will disappear and they won't get killed",
		"BraveGirl: I prefer to using my gun than stomping",
		"Agni's Father: Please reduce the number of blood sheds if possible",
		"AgniPuthiran: You are right, father. But it is in your own interest, you can either kill or not",
		"BraveGirl: I will definitely try to reduce blood sheds!! But I can't promise anything'",
		"AgniPuthiran: Stay alert and move forward carefully..Catch you later",
		"BraveGirl: See you later, guys!!!"
	]
	conversation_layer.set_conversation_script(scripts)
	conversation_layer.set_duration_between_scripts(5)

func _process(delta: float) -> void:
	agniputhiran_node._hide_pointer()
	agni_father_node._hide_pointer()
	bravegirl_node._hide_pointer()
	var current_speaker = conversation_layer.get_current_speaker_node()
	if current_speaker == "AgniPuthiran":
		agniputhiran_node._show_pointer()
	elif current_speaker == "BraveGirl":
		bravegirl_node._show_pointer()
	elif current_speaker == "Agni's Father":
		agni_father_node._show_pointer()
	if(conversation_layer.get_is_completed_conversation()):
		$"ConversationLayer/CanvasLayer/FadeIn".show()
		$"ConversationLayer/CanvasLayer/FadeIn".fade_in()
