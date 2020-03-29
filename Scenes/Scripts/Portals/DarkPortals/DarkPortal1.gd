extends Node2D

onready var life_deciding_timer = $"PortalLifeDeciderTimer"
onready var evil_summon_timer = $"EvilSummonTimer"
onready var summon_position = $"SummoningLocation"
export (PackedScene) var male_zombie
export (PackedScene) var female_zombie
var start_time
var summon_time

# Called when the node enters the scene tree for the first time.
func start_timer() -> void:
	life_deciding_timer.start(start_time)
	evil_summon_timer.start(summon_time)

func set_start_time(time : int):
	start_time = time

func set_summon_timer(time:int):
	summon_time = time

func _on_EvilSummonTimer_timeout() -> void:
	var randomNumber = int(rand_range(0,10))
	var scene_data
	if(randomNumber%2 == 0):
		scene_data = male_zombie.instance()
	else:
		scene_data = female_zombie.instance()
	scene_data.set_name("Enemy" + str(get_child_count()))
	get_parent().add_child(scene_data)
	scene_data.position = summon_position.global_position
	
func _on_PortalLifeDeciderTimer_timeout() -> void:
	# Explosion starts here
	evil_summon_timer.stop()
	$"Explode".play()

func _on_Explode_finished() -> void:
	queue_free()
