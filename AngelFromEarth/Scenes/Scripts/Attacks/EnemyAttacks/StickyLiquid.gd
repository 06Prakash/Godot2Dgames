extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"

onready var weapon = $"WeaponImage"

func _ready() -> void:
	weapon.visible = false
	$"VisiblityTimer".start(1)
	set_process(false)

func _process(delta: float) -> void:
	weapon.visible = true
	._process(delta)

func _set_direction(direction : int):
	._set_direction(direction)

func _get_type() -> String:
	return "Normal"

func _on_StickyLiquid_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Hero")):
		area.reduce_health()


func _on_VisiblityTimer_timeout() -> void:
	queue_free()


func _on_StickyLiquid_body_entered(body: KinematicBody2D) -> void:
	if body == null:
		return
	if body.name != "Player":
		return
	else:
		body.reduce_health()
