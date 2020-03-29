extends "res://Scenes/Scripts/Attacks/RangedAttacks.gd"

onready var MoveAreaEffect = $MoveAreaEffect
onready var attack_disappear = $DisappearTimer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _direction = int(get_parent().get_node("Player/SwordRangeArea/CollisionShape2D").position.x < 0)
	_attack_direction(_direction)
	MoveAreaEffect.play()
	attack_disappear.start(0.4)

func _attack_direction(_direction : int):
	if _direction < 0 and position.x > 0:
		position.x *= direction
		
func _on_SwordWaveAttack_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		area.get_parent().hit_by_sword()


func _on_DisappearTimer_timeout() -> void:
	queue_free()


func _on_MoveAreaEffect_animation_finished(anim_name: String) -> void:
	queue_free()
