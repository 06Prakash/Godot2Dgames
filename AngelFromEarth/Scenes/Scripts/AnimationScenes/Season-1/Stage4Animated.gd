extends Node2D

onready var conversation_layer = $"ConversationLayer"
const NEXT_STAGE : String= "res://Scenes/SceneList/Season-1 Stages/AnimatedStage5.tscn"
onready var agniputhiran_node = $"AgniPuthiran"
onready var giant_spider_node = $"GiantSpider"
var shake_now_count
var scripts
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._stop_all_musics()
	if(get_tree().paused):
		get_tree().paused = false
	$"ConversationLayer/CanvasLayer/FadeIn".show_behind_parent = true
	scripts = [
		"Giant Spider: PLEASE KILL ME!!!!!!",
		"AgniPuthiran: You can talk??!!",
		"Giant Spider: Yes, Please Kill me!! I won't be able to save my baby spiders'",
		"AgniPuthiran: What are you talking about?",
		"Giant Spider: Our species got attacked by reapers, zombies and golems",
		"Giant Spider: We are able to hold them good, but these monsters started to have upper hand for past few days",
		"Giant Spider: They attained some magical powers due to which they have captured most of my beings",
		"Giant Spider: They are threatening to kill them, if we refuse to do what they command",
		"AgniPuthiran: Answer me!! Who is this 'they'? You are referring to",
		"Giant Spider: We hear their voice alone but never seen any of them",
		"AgniPuthiran: So they are planning to take over this village and but to keep every one tied up, so that they can rule us to",
		"Giant Spider: Exactly!! but how you figured this out",
		"AgniPuthiran: Simple by the way you attacked, you have strong and poisonous stings but you are not using them",
		"AgniPuthiran: You are using only string shots to keep me tied up",
		"Giant Spider: But you are very strong, not sure why the string are not having much effect on you",
		"AgniPuthiran: Please let me know, How to rescue your species that are being held by these evil creatures",
		"Giant Spider: Really Humans are really humans, I really appreciate your help",
		"AgniPuthiran: Please go on",
		"Giant Spider: They are keeping us contained inside the deep jungle, if you can help please liberate us from these evils",
		"AgniPuthiran: Sure Will do it",
		"AgniPuthiran: You can stay near our village, It will be safe",
		"AgniPuthiran: I will discuss with my Sun village wise people and decide on what to do next",
		"Giant Spider: I will protect your village along with your village resistance",
		"AgniPuthiran: Thank you very much!!!"
	]
	$"Camera2D/ScreenShake"._set_required_value(5)
	conversation_layer.set_conversation_script(scripts)
	conversation_layer.set_duration_between_scripts(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_speaker = conversation_layer.get_current_speaker_node()
	agniputhiran_node._hide_pointer()
	giant_spider_node._hide_pointer()
	if current_speaker == "AgniPuthiran":
		agniputhiran_node._show_pointer()
	elif current_speaker == "Giant Spider":
		giant_spider_node._show_pointer()
	if(conversation_layer.get_is_completed_conversation()):
		conversation_layer.show_fade_in()

func _on_FadeIn_fade_in_finished() -> void:
	get_tree().change_scene(NEXT_STAGE)
