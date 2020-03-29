extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"

onready var weapon = $"WeaponImage"
var engaged_direction = 1
onready var vanishWeapon = $"DisappearTimer"

func _ready() -> void:
	weapon.visible = false
	$"SwordSwingAudio".play()
	vanishWeapon.start(0.25)
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
	return "AreaEffect"

func _on_DisappearTimer_timeout() -> void:
	queue_free()

func _on_SwordSwingAttack_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		area.get_parent().hit_by_sword(area.get_parent().get_can_hurt(), engaged_direction)
		if(area.is_in_group("BigEnemy")):
			queue_free()
