extends Node2D

var wooden_arrow = preload("res://Assets/Attacks/Weapons/Arrow.png")
var sun_beam = preload("res://Assets/Attacks/RangedAttacks/SunRay1.png")
var sword1 = preload("res://Assets/Heroes/VillageLeader/Weapon/Sword.png")
var bullet1 = preload("res://Assets/Attacks/RangedAttacks/FireBullet1/bullet1.png")
var attack_available = [sword1, bullet1, sun_beam, wooden_arrow]
onready var attack_image = $PanelContainer/AttackImage

func _selected_attack_change(SelectAttack: String) -> void:
#	attack_image.set_texture(attack_available[SelectAttack])
	if SelectAttack == "sword1":
		attack_image.set_texture(sword1)
	elif SelectAttack == "bullet1":
		attack_image.set_texture(bullet1)
	elif SelectAttack == "wooden_arrow":
		attack_image.set_texture(wooden_arrow)
	elif SelectAttack == "sun_beam":
		attack_image.set_texture(sun_beam)


func _on_ChangeWeapon_pressed() -> void:
	var SelectAttack = get_tree().get_nodes_in_group("Hero")[0].get_next_attacks()
	_selected_attack_change(SelectAttack)
