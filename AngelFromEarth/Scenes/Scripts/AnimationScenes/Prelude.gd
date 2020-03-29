extends Node2D

onready var scripts = []
onready var current_script = -1
onready var script_timer = $"ScriptControlTimer"
onready var camera_control_timer = $"CameraController"
onready var animation_player1 = $AnimationPlayer
export var popup_panel:PackedScene 

var popup_panel_instance
var start_scene = "res://Scenes/SceneList/Season-1 Stages/Stage1.tscn"
var velocity = Vector2(100,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player1.play("TitleAnimation")
	scripts = ["This small village is the Sun village, It is named after Sun God, It was once a peaceful village but suddenly evil monsters started to appear near jungle",
	"These creatures never dared to enter into this village and they will come only after sun set",
	"But now, At every evening this Sun village is getting attacked by random evil creatures",
	"This time they are facing the horde of zombies, Their walls were giving them the higher edge but now it got broken by these hordes of zombies",
	"There are few brave hearts in this town, they are trying to push those zombies back",
	"Suddenly these evil creatures started to enter through weird portal and started entering the village",
	"Which was totally unexpected by the guarding people and brave hearts, These evil monsters already started sabotaging the village",
	"In the mean time, Leader of this small village 'AGNI PUTHIRA' who is a great devotee of Sun god, went into the jungle for deep meditation few days back, he left his father the news of his return back to his village through the messenger",
	"His father is the old hunter who used to hunt dangerous animals and evil creatures during young age and now, he is taking care of this village during his son's absence",
	"He gathered up few wise people of the village to speak about the situation and to know the status of their defenses while our heroes are holding the zombies",
	"Builder:  Our walls are broken by these zombies, We are not even having enough resources to build them back",
	"Villager: How many hours we can lasts if this situation persists",
	"Agni's Father: Our Leader is a great fighter and he returned back from his long days of dedicated prayer to Sun god today",
	"Villagers: Can he be able to hold these evil monsters for that much long, single handedly?",
	"Agni's Father: He will hold these army of evil creatures until morning",
	"Agni's Father: We will discuss about the solution to this problem tomorrow morning, for now we need to survive",
	"Agni's Father: Our Leader, My Son!!!. He is very strong and skilled, blessed by sun god and has magic sun sword with him granted by Sun god himself",
	"Agni's Father: I have absolute faith in my son, he will definitely hold these monsters till morning.",
	"Villagers: OH MY GOD!!!... Those evil creatures are coming from portals directly into our village directly, our heroes won't hold long",
	"Builder: ....",
	"Villagers: .....Why are you here, Bravve girl. you should be holding the zombies",
	"Brave Girl: We won't be able to hold much further, Ninja boy got hurt by zombies, we are surrounded.",
	"Brave Girl: There are three portals that keep on spawning zombies",
	"Builder: Oh my god, We all going to be dead meat by morning",
	"Agni's Father: Have faith guys, I can feel my son has entered this village gates",
	"Agni's Father: Now its time for zombies to run",
	"Brave girl: Don't take me wrong guys, I guess this old man gone mad?'",
	"Brave girl: We are having an army of zombies incoming from that ugly portal",
	"Brave girl: Putting a faith in single boy?? Forget it, I can cover the east while you guys can escape through west.",
	"Agni's Father: Can you feel the silence in air, and evil creatures stopped for a moment",
	"It looks like someone is approaching the village like a Knight",
	"Villagers: Is that our leader coming in battle suite?",
	"Brave girl: Is he your son looking like a knight with some weird armour and sword?",
	"Agni's Father: Yes he is... A light in the dark, Now zombies start to face your deaths",
	"Brave girl: He looks handsome and strong, but can he able to hold that zombie army, I dont think so I will go and help him out",
	"Agni's Father: Just wait and watch girl, No one ever dared to stand infront of my son, while he waves his sword, it will emit an energetic wave that can break through almost anything",
	"Agni's Father: That was given to him by Sun god himself as a result of having high dedication towards Sun God",
	"Brave girl: Is it so? Let's watch him in action then.."
	]
	camera_control_timer.start(14)

func _on_ScriptControlTimer_timeout() -> void:
	_move_to_next_script()

func _move_to_next_script() -> void:
	if(current_script < scripts.size()-1):
		current_script += 1
		popup_panel_instance._update_label(scripts[current_script])
		script_timer.start(4)
	else:
		get_tree().change_scene(start_scene)

func _on_CameraController_timeout() -> void:
	$CameraController.stop()
	animation_player1.stop()
	velocity.x *= -1
	$"LayerContainer/MainTitle".text = ""
	popup_panel_instance = popup_panel.instance()
	add_child(popup_panel_instance)
	popup_panel_instance.global_position.x = $Position2D.global_position.x + 100
	popup_panel_instance.global_position.y = $Position2D.global_position.y + 100
	var camera = $"Position2D/Camera2D"
	camera.position.x = popup_panel_instance.global_position.x + 300
	camera.position.y = popup_panel_instance.global_position.y + 300
	popup_panel_instance._toggle_popup(true)
	script_timer.start(2)


func _on_Music_finished() -> void:
	$"LayerContainer/MainTitle/Music".play()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	animation_player1.stop()
	$"Position2D/Camera2D".current = true
