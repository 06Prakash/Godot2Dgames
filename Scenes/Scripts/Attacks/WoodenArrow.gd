extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"

onready var weapon = $"WeaponImage"
func _ready() -> void:
	weapon.visible = false
	$"VisibleTimer".start()
	set_process(false)

func _process(delta: float) -> void:
	weapon.visible = true
	._process(delta)

func _on_WoodenArrow_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		area.get_parent().hit_by_arrow_attack()
		queue_free()

func _set_direction(direction : int):
	if direction < 0:
		$"WeaponImage".flip_h = true
	._set_direction(direction)

func _get_type() -> String:
	return "Normal"

func _on_VisibleTimer_timeout() -> void:
	queue_free()
