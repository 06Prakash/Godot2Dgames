extends "res://Scenes/Scripts/ActorScript.gd"

onready var score_points = 100
onready var anim_sprite = $ZombieImage
onready var explode = $"Exploding"
onready var speedScaling
var can_hurt = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_sprite.play("Walk")
	speedScaling =  0.3 * 4
	_velocity.x = speed.x * speedScaling
	$"BurnType2".visible = false
	if((randi()%100) % 5 == 0):
		zombie_threatening_msg()
		$"TextTimer".start(4)

func get_can_hurt() -> bool:
	return can_hurt

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1
		anim_sprite.flip_h = true
	if _velocity.x > 0:
		anim_sprite.flip_h = false
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func stomped_hard():
	perform_stomped_hard_operation(score_points)

func hit_by_arrow_attack():
	can_hurt = false
	anim_sprite.play("Dead")
	explode.play()

func hit_by_sword(hurting_possible : bool, attack_engaged_direction:int):
	if(hurting_possible):
		.hit_by_sword(hurting_possible, attack_engaged_direction)
		anim_sprite.play("Dead")
		explode.play()

func hit_by_fire_contact(CatchFire: bool):
	if(CatchFire && can_hurt):
		can_hurt = false
		$"BurnType2".visible = true
		$"BurnType2/FlameBurn".visible = true
		$"BurnType2/BurnArea".visible = true
		$AttackArea2D.set_deferred("disabled",true)
		explode.play()

func _on_Exploding_finished() -> void:
	_update_after_faint(score_points)

func _on_AttackArea2D_body_entered(body: KinematicBody2D) -> void:
	if !can_hurt:
		return
	if body == null:
		return
	elif body.name != "Player":
		return
	get_parent().get_node("Player").reduce_health()
	queue_free()


func _on_TextTimer_timeout() -> void:
	$"ZombieImage/PlayerSpeechArea/SpeechLayer".text = ""
