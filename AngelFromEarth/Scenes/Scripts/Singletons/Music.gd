extends Node2D

var set_stream
var music_stopped = false

func _play_music(stream : String = "dnb"):
	_stop_all_musics()
	set_stream = stream
	if stream == "dnb":
		$DnB.play()
	elif stream == "house":
		$House.play()
	elif stream == "shoot":
		$Shoot.play()
	elif stream == "sword":
		$Sword.play()
	elif stream == "explode":
		$Explode.play()

func _stop_all_musics():
	$DnB.stop()
	$House.stop()

func _stop_music(stream: String = "dnb"):
	if stream == "dnb":
		$DnB.stop()
	elif stream == "house":
		$House.stop()
	music_stopped = true

func _on_DnB_finished() -> void:
	if music_stopped:
		music_stopped = false
		return
	$DnB.play()


func _on_House_finished() -> void:
	if music_stopped:
		music_stopped = false
		return
	$House.play()
