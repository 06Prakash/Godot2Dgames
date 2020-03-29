extends Node2D


var scripts
onready var conversation_layer = $"ConversationLayer"
const NEXT_STAGE : String= "res://Scenes/SceneList/Season-1 Stages/Stage3.tscn"
onready var agniputhiran_node = $"AgniPuthiran"
onready var agni_father_node = $"Agni's Father"
onready var bravegirl_node = $"BraveGirl"
onready var ninja_boy_node = $"Ninja boy"
var shake_now_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	shake_now_count = 3
	scripts = [
		"BraveGirl: Wow! Wow! Wow! what a great display of strength, speed and power",
		"Ninja boy: You are really super strong, Good thing you came in correct time",
		"AgniPuthiran: Thank you guys!!",
		"AgniPuthiran: I have some questions, who are you guys first? I never seen you in this village",
		"BraveGirl: We are just passing on and having shelter in this small village for past two days",
		"Ninja Boy: When we saw that your village is in trouble, we lended our hands to protect it",
		"BraveGirl: Too bad, they are too many of them and very ugly tooo",
		"AgniPuthiran: I guess you guys know nothing about this evil happenings, Thanks for protecting the village!!",
		"AgniPuthiran: Seems the ninja boy got hurt in his hands, Please stay and rest here in the village",
		"Ninja Boy: These stupid zombies somehow took me by surprise",
		"BraveGirl: It's ok ninja boy, you handled things so well",
		"BraveGirl: I need some rest too, can I stay here as well",
		"AgniPuthiran: You both guys are welcome to stay here",
		"Agni's Father: Agni, I guess we need to know why these evil beings got upper hand for the past few days",
		"AgniPuthiran: You are right, father. How are you?",
		"Agni's Father: These two guys actually came as a blessing to this village during your absence'",
		"AgniPuthiran: Nice to hear that!!",
		"Agni's Father: Wait!! why the ground is shaking",
		"BraveGirl: MY GOD, A GIANT SPIDER!!!! Approaching towards us",
		"AgniPuthiran: What on earth?!! I never seen such a spider before",
		"BraveGirl: AgniPuthiran, we need to evacuate the village",
		"AgniPuthiran: We don't need to, Spider seems to be spitting some ball of sticky threads",
		"AgniPuthiran: I dont think those sticky balls will hurt us, but we need to be cautious since we don't know its motive and it power",
		"BraveGirl: You are right!! and that sticky balls are too ugly than zombies",
		"AgniPuthiran: Please stay inside my house and also take ninja boy with you",
		"BraveGirl: What you are planning to do??!!",
		"AgniPuthiran: By the grace of the Sun god, I am going to burn this creature, in the same place where it stands",
		"BraveGirl: You are planning to fight that oversized spider!! Be careful",
		"AgniPuthiran: I am always careful..Catch you later"
	]
	conversation_layer.set_conversation_script(scripts)
	conversation_layer.set_duration_between_scripts(5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_speaker = conversation_layer.get_current_speaker_node()
	agniputhiran_node._hide_pointer()
	bravegirl_node._hide_pointer()
	ninja_boy_node._hide_pointer()
	agni_father_node._hide_pointer()
	if current_speaker == "AgniPuthiran":
		agniputhiran_node._show_pointer()
	elif current_speaker == "BraveGirl":
		bravegirl_node._show_pointer()
	elif current_speaker == "Ninja Boy":
		ninja_boy_node._show_pointer()
	elif current_speaker == "Agni's Father":
		agni_father_node._show_pointer()
		if conversation_layer.need_to_shake():
			$Camera/ScreenShake._set_required_value(10)
	if(conversation_layer.get_is_completed_conversation()):
		$"FadeIn".show()
		$"FadeIn".fade_in()


func _on_FadeIn_fade_in_finished() -> void:
	get_tree().change_scene(NEXT_STAGE)
