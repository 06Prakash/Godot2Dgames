extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"
onready var weapon = $"WeaponImage"
var engaged_direction = 1

func _ready() -> void:
	weapon.visible = false
	set_process(false)

func _process(delta: float) -> void:
	weapon.visible = true
	._process(delta)

func _set_direction(direction : int):
	if direction < 0:
		$"WeaponImage".flip_h = true
		engaged_direction = -1
	._set_direction(direction)

func _get_type():
	return "Energy"

func _on_DisappearTimer_timeout() -> void:
	queue_free()


func _on_YellowSunRay_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		area.get_parent().hit_by_fire_attack("BurnType2")
