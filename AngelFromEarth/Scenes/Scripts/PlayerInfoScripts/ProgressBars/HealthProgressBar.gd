extends Node2D

onready var texture_progress = $"TextureProgress"
onready var update_tween = $TextureProgress/Tween
export (Color) var healthy_color
export (Color) var caution_color
export (Color) var danger_color

export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.3


# Function to update the progress bar
func _update_progress_bar(new_value : float):
	update_tween.interpolate_property(texture_progress, "value",  texture_progress.value, new_value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
