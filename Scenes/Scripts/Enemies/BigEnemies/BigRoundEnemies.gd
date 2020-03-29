extends "res://Scenes/Scripts/ActorScript.gd"

class_name BigRoundEnemies
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export (PackedScene) var attack
var health_level
var energy_level
var can_hurt = true
var CatchFire = true
var fainted = false
var score_points = 10000
var coins = 100
onready var burnType = $BurnType1
onready var explode = $Exploding
onready var attack_timer = $"AttackTimer"
onready var progress_bar = $"AnimatedSprite/ProgressBar"
var speed_scaling = 1
var just_now_got_hit = false
var inertia_to_turn = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_speed_scaling(scale_speed: int):
	speed_scaling = scale_speed

func set_max_health(max_value):
	max_health = max_value

func set_health(health):
	health_level = health

func set_energy(energy):
	energy_level = energy

func _set_attack_time_gap(time_gap: int):
	attack_timer.start(time_gap)

func _attack():
	if(attack != null):
		var attack_direction = get_tree().get_nodes_in_group("Hero")[0].global_position.x - global_position.x
		if attack_direction > 0:
			attack_direction = 1
		else:
			attack_direction = -1
		.use_ranged_attack(attack_direction, attack)
	var try_attack = 10;

func get_can_hurt() -> bool:
	return can_hurt

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

func reduce_health(health_reduction:int):
	if health_level > 0:
		health_level -= health_reduction
	else:
		fainted = true
		hit_by_fire_contact(true)
	progress_bar._update_progress_bar((health_level * 100)/max_health)

func hit_by_sword(hurting_possible : bool, attack_engaged_direction:int):
	if(hurting_possible and not just_now_got_hit):
		explode.play()
		just_now_got_hit = true

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall() and not inertia_to_turn:
		_velocity.x *= -1
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		inertia_to_turn = true
		$"Inertia Timer".start(5)
		return
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_Exploding_finished() -> void:
	just_now_got_hit = false
	var score_to_update = score_points * (float(max_health - health_level) / max_health)
	_update_after_faint(score_to_update, "big_enemy")
	if (fainted):
		queue_free()
	

func _on_AttackArea2D_body_entered(body: KinematicBody2D) -> void:
	if !can_hurt:
		return
	if body == null:
		return
	elif body.name != "Player":
		return
	get_parent().get_node("Player").reduce_health()

func _on_AttackTimer_timeout() -> void:
	_attack()


func _on_Inertia_Timer_timeout() -> void:
	inertia_to_turn = false
