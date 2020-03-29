extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"

onready var weapon = $"WeaponImage"
var engaged_direction = 1
onready var bulletTravelDistanceDecider = $DisappearTimer

func _ready() -> void:
	weapon.visible = false
	set_process(false)
	bulletTravelDistanceDecider.start(2)

func _process(delta: float) -> void:
	weapon.visible = true
	._process(delta)

func _set_direction(direction : int):
	if direction < 0:
		$"WeaponImage".flip_h = true
		engaged_direction = -1
	._set_direction(direction)

func _get_type():
	return "Normal"

func _on_DisappearTimer_timeout() -> void:
	queue_free()

func _on_FireBullet_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		if(area.is_in_group("BurnType1")):
			area.get_parent().hit_by_fire_attack("BurnType1")
		elif(area.is_in_group("BurnType2")):
			area.get_parent().hit_by_fire_attack("BurnType2")
		queue_free()
