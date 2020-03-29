extends Node2D

var set_stream

func _play_music(stream : String = "dnb"):
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




func _on_DnB_finished() -> void:
	$DnB.play()


func _on_House_finished() -> void:
	$House.play()
