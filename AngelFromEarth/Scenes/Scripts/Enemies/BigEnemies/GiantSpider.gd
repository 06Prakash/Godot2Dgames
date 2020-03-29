extends BigRoundEnemies

export (PackedScene) var spiders

onready var spawning = $SpiderSpawning

var health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"AnimatedSprite".play("Walk")
	.set_health(health)
	._set_attack_time_gap(5)
	.set_max_health(health)
	spawning.start(1)
	set_speed_scaling(4)
	_velocity.x = -speed.x * speed_scaling
	pass # Replace with function body.

func hit_by_arrow_attack():
	if(health > 0):
		.reduce_health(4)
	else:
		fainted = true

func hit_by_sword(hurting_possible : bool, attack_engaged_direction:int):
	.reduce_health(5 * int(.got_critical_hit()))
	.hit_by_sword(hurting_possible, attack_engaged_direction)

