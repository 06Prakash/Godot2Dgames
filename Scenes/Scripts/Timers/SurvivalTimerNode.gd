extends Node2D

onready var survivaltimer = $SurvivalTimer
onready var survivaltimedisplay = $SurvivalTimeDisplayer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var timer_message = "Survival Time"
var timer_stopped = false
var kill_at_timer_stop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if(!timer_stopped):
		var timeleft = get_remaining_time()
		var minleft = int(timeleft / 60.0)
		var secleft = int(timeleft) % 60
		survivaltimedisplay.set_text(str(timer_message," : ",minleft, ":", secleft))

func _start_timer(msg:String, total_time: int, kill_all_at_end: bool = true):
	timer_message = msg
	survivaltimer.start(total_time)
	kill_at_timer_stop = kill_all_at_end

func get_remaining_time()-> float:
	return survivaltimer.time_left

func get_survival_timer_message() -> String:
	return timer_message

func is_survival_timer_stopped() -> bool:
	return timer_stopped

func _on_SurvivalTimer_timeout() -> void:
	if kill_at_timer_stop:
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.queue_free()
		get_tree().call_group("Enemy","hit_by_arrow_attack")
		timer_stopped = true
