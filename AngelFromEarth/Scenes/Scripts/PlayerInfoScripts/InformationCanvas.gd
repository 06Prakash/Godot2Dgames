extends Node2D

export (PackedScene) var score_scene
export (PackedScene) var energy_scene
export (PackedScene) var selected_attack_scene
export (PackedScene) var survival_timer
onready var scoreposition = $InfoLayer/ScorePosition
onready var energyposition = $InfoLayer/EnergyPosition
onready var selectedAttackPostion = $InfoLayer/SelectedAttackDisplay
onready var survivalTimerPostion = $InfoLayer/SurvivalTimer
onready var fade_in = $InfoLayer/FadeIn

var score_area
var survival_time
var current_health_level = 0
var current_energy_level = 0
var current_score = 0
var health_store = []
var energy_store = []
var energy_positions = []
var next_scene_to_load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_area = score_scene.instance()
	add_child(score_area)
	score_area.position = scoreposition.position
	survival_time = survival_timer.instance()
	add_child(survival_time)
	survival_time.position = survivalTimerPostion.position

func _update_survival_time(msg:String, time: int, kill_at_end: bool = true):
	survival_time._start_timer(msg, time, kill_at_end)

func is_survival_timer_stopped() -> bool:
	return survival_time.is_survival_timer_stopped()

func reduce_energy():
	if(energy_store.size() > 0):
		remove_child(energy_store[energy_store.size()-1])
		energy_store.pop_back()

func increase_energy(energy_level : int, Max_energy_level : int):
	while(energy_store.size() < Max_energy_level and energy_level < Max_energy_level):
		var energy_data = energy_scene.instance()
		add_child(energy_data)
		energy_data.position = energy_positions[energy_store.size()]
		energy_store.append(energy_data)
		
func total_energy(energy_level: int):
	if current_energy_level != energy_level:
		var space_energy_position = 50
		var initial_energy_position :Vector2 = energyposition.position
		var start_level = current_energy_level - energy_level
		if current_energy_level < energy_level:
			start_level *= -1
			for _i in range(0, start_level):
				var energydata = energy_scene.instance()
				add_child(energydata)
				energydata.position = initial_energy_position
				energy_positions.append(initial_energy_position)
				initial_energy_position.x -= space_energy_position
				energy_store.append(energydata)
			current_energy_level = energy_level

func attackSelected(selected_attack: String):
	var selectedAttack = selected_attack_scene.instance()
	add_child(selectedAttack)
	selectedAttack.position = selectedAttackPostion.position
	selectedAttack._selected_attack_change(selected_attack)

func update_score(score: int):
	score_area._set_score_Text(score)

func transition_to_next_stage(next_scene: String):
	next_scene_to_load = next_scene
	fade_in.show_behind_parent = false
	fade_in.show()
	fade_in.fade_in()
	
	
func _on_FadeIn_fade_in_finished() -> void:
	var status_of_transition = get_tree().change_scene(next_scene_to_load)
	print("Status of transition : " + str(status_of_transition))
