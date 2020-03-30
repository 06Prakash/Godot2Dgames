extends Control

var scene_path_to_load = []
var buttonName
var music_for_this_page = "dnb"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music._play_music(music_for_this_page)
	for button in $Menu/CenterRow/Buttons.get_children():
		if(button.scene_to_load != null):
			button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_FadeIn_fade_in_finished() -> void:
	Music._stop_music(music_for_this_page)
	get_tree().change_scene(scene_path_to_load)


func _on_Controls_pressed() -> void:
	scene_path_to_load = $Controls.scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
