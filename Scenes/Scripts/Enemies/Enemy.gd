extends "res://Scenes/Scripts/ActorScript.gd"

onready var speedScaling
onready var explode = $"Exploding"
onready var sprite = $"Enemies"
onready var burnType = $BurnType1
var score_points = 50
var can_hurt = true

func _ready() -> void:
	set_physics_process(false)
	burnType.visible = false
	var animations = ["Lizard", "Octopus", "Owl", "Spider"]
	var selectAnimation = int(rand_range(0, animations.size()))
	sprite.play(animations[selectAnimation])
	speedScaling =  0.1 * 2
	_velocity.x = -speed.x * speedScaling

func change_to_spider():
	sprite.play("Spider")

func get_can_hurt() -> bool:
	return can_hurt

func stomped_hard():
	perform_stomped_hard_operation(score_points)

func hit_by_fire_contact(CatchFire: bool):
	if(CatchFire and can_hurt):
		can_hurt = false
		burnType.visible = true
		$"BurnType1/FlameBurn".visible = true
		$"BurnType1/BurnArea".visible = true
		explode.play()

func hit_by_arrow_attack():
	can_hurt = false
	$ArrowHitDisappear.play("disappear")
	explode.play()


func hit_by_sword(hurting_possible : bool, attack_engaged_direction:int):
	if(hurting_possible):
		var power_level: int = get_sword_power()
		_velocity.x *= power_level if attack_engaged_direction > 0 else -power_level
		_velocity.y -= 25 * (randi()%20 +1)
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		$"EnemyPhysicArea".set_deferred("disabled", true);
		$"AttackArea2D".set_deferred("disabled", true);
		$"AttackArea2D/AttackArea".set_deferred("disabled", true)
		$"StompingArea".set_deferred("disabled", true);
		$"StompingArea/StompArea".set_deferred("disabled", true);
		explode.play()


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_Exploding_finished() -> void:
	_update_after_faint(score_points)

func _on_AttackArea2D_body_entered(body: KinematicBody2D) -> void:
	if !can_hurt:
		return
	if body == null:
		return
	elif body.name != "Player":
		return
	body.reduce_health()
	queue_free()
