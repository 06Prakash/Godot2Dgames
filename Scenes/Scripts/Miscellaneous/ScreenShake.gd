extends Node2D

onready var camera = get_parent()
var shake_now
var shake_amount = 0.0

func _ready() -> void:
	shake_now = true
	set_process(false)	

func _process(_delta):
	camera.set_offset(Vector2(
		rand_range(-1.0, 1.0) * shake_amount,
		rand_range(-1.0, 1.0) * shake_amount
	))
	if(shake_amount > 0 and shake_now):
			$Exploding.play()
			shake_now = false

func _set_required_value(_amplitude = 20):
	shake_amount = _amplitude
	set_process(true)

func _reset() -> void:
	shake_amount = 0.0
	set_process(false)
	shake_now = true

func _on_Exploding_finished() -> void:
	_reset()
