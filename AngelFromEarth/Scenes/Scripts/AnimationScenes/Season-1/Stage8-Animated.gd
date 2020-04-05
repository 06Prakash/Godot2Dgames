extends Node2D

onready var conversation_layer = $"ConversationLayer"
onready var reaper_node = $"Reaper"
onready var bravegirl_node = $"BraveGirl"

const NEXT_STAGE : String= "res://Scenes/SceneList/Season-1 Stages/Stage6.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (get_tree().paused):
		get_tree().paused = false
	Music._stop_all_musics()
	var scripts = [
	"BraveGirl: Seems like there is one reaper alone here, I never thought reapers can walk on earth like that",
	"BraveGirl: I need to get information about what is going on",
	"BraveGirl: Reapers are the beings that actually take soul as far as I know",
	"BraveGirl: But why these reapers are just wamdering over here?",
	"BraveGirl: I have a strong feeling like I can talk to them to know more about what is going on",
	"BraveGirl: Ahhhhh! Hello.... Reaper??",
	"Reaper: You are addressing me?!!",
	"BraveGirl: Yup!! Do you have name so it will be easy to call you",
	"Reaper: I don't think you need to call me'",
	"BraveGirl: Why so?",
	"Reaper: Because I will come when your time comes!!! He he he....",
	"BraveGirl: Ok Stupid Reaper!!! Good joke",
	"Reaper: Stuuuuppppiiiddd!!! How dare you???",
	"Reaper: But I really like your guts, girl",
	"Reaper: You can address me as Reaper, I can feel that you chased some reapers in the last area",
	"BraveGirl: Actually I stomped few and Burnt few, thought I killed them",
	"Reaper: No, Reapers won't die like that with human made weapons",
	"BraveGirl: Oh Ok so they just disappeared? After seeing human presence??",
	"Reaper: Exactly girl!! We are not your enemies, we came here to find out the reason",
	"BraveGirl: What reason??!!",
	"Reaper: We are not able to get the souls from already dead beings",
	"BraveGirl: You mean the zombies??",
	"Reaper: Yes!!",
	"BraveGirl: Got any ideas?!",
	"Reaper: Till now we though some angels are using the souls for some purpose",
	"BraveGirl: Till now?!! Then what now?",
	"Reaper: Biggest problem here is we can feel the break in timeline of worlds",
	"Reaper: We are starting to feel mostly like these are human activities from the future.",
	"BraveGirl: Whaaaaatttttt??!!!",
	"BraveGirl: Can't you just go and reap them??!!'",
	"Reaper: They are more advanced not sure how this much advancement",
	"BraveGirl: So what is their plan??!!",
	"Reaper: They want to rule the past so that they can rule the present and future",
	"BraveGirl: But How these zombies or ....dead people are involved??",
	"Reaper: Few are not dead people, they are normal people they are converted to zombies",
	"BraveGirl: Oh Poor Souls, I killed them with my guns....",
	"Reaper: Thanks to you We are able to claim their souls!!",
	"Reaper: I have one message for your leader 'AgniPuthiran'",
	"BraveGirl: What was that?",
	"Reaper: He needs to get healing power from sun god to heal the zombies back to humans",
	"BraveGirl: Why can't I get that??!! Even I can heal people after that'",
	"Reaper: He is special girl, He is not a human, He is the only one who can claim that power",
	"BraveGirl: Ok Makes sense, he was able to use super powers easily I already saw that",
	"Reaper: Ask him to go to sun mountain one sage is waiting for him'",
	"Reaper: He need to comple certain trials to get that power, So ask him to go there immediately, Before too late",
	"Reaper: Now you can able to see the portal at the end of this area and you can reach your sun village through that"
	]
	conversation_layer.set_conversation_script(scripts)
	conversation_layer.set_duration_between_scripts(5)

func _process(delta: float) -> void:
	reaper_node._hide_pointer()
	bravegirl_node._hide_pointer()
	var current_speaker = conversation_layer.get_current_speaker_node()
	if current_speaker == "Reaper":
		reaper_node._show_pointer()
	elif current_speaker == "BraveGirl":
		bravegirl_node._show_pointer()
	if(conversation_layer.get_is_completed_conversation()):
		$"ConversationLayer/CanvasLayer/FadeIn".show()
		$"ConversationLayer/CanvasLayer/FadeIn".fade_in()

