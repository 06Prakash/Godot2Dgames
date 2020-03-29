extends Area2D


export var speed = 800
export var damage = 10
var start_position = 0
var threshHold_distance = 1000
var _direction = 1

func _set_start_position(starting_position: Vector2):
	start_position = starting_position.x + 200
	set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	threshHold_distance += start_position
	if _direction != 0:
		threshHold_distance *= _direction
	position.x += speed * delta * _direction

func _set_direction(direction : int):
	_direction = direction
