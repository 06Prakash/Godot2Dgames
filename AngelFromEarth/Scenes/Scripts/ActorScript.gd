extends KinematicBody2D

class_name ActorScript
	
const FLOOR_NORMAL = Vector2.UP
export var speed = Vector2(300.0, 1100.0)
export var gravity = 2000.0
var enhancer = 50
var total_attacks = 1
# Player specific properties
var select_attack = 0
var melee_attack_ended = true
var melee_attack_direction
var engaged_attack_direction = 1
var regenerate_energy = false
var healthlevel:int
var energylevel:int
var kill_count:int
var protected: int
var player_score: int
var coin_collected_count:int = 0
var max_health:int
var max_energy:int
var stage_completed:bool
var attacks_available = []
var current_player: String
var current_highscore


const SAVE_PATH = "res://save.json"

var threatening_scripts = ["You can't stand a chance against me",
							"My strength is divine",
							"Feel My Wrath",
							"For Justice",
							"For the sun god!!!",
							"Run Away Fools!!!",
							"Taste my power!!!"
							]

var Brave_girl_threatening_scripts = ["Run away you ugly creatures",
							"Taste my bullets",
							"A piece of cake",
							"For friends and family",
							"Take this shot!!!",
							"Taste my fire power!!!"
							]


var praising_scripts = [
							"Beautiful",
							"Wonderful"
]
var pain_scripts = [
	"OOUUCCHH!!!, That hurts you brat",
	"You hurted me now you will pay",
	"Ahh!! I am bleeding!!"
]

var brave_girl_pain_scripts = [
	"You will taste my bullet soon enough..",
	"Never expect mercy after this!!",
	"You hurted me, Ugly being!!"
]

var zombie_scripts = [
	"Grrrrrrr",
	"Arrrghhhh",
	"More blood"
]
# var _velocity: = Vector2(300, 0) # 300 pixels per second in x axis and 0 on y-axis
var _velocity: = Vector2.ZERO # 300 pixels per second in x axis and 0 on y-axis
var Score = 0

func get_camera_limits():
	var camera_control = $"Camera2D"
	var camera_limit_array = get_tree().get_nodes_in_group("stage")[0].get_camera_limits()
	camera_control.limit_bottom = camera_limit_array[0]
	camera_control.limit_right = camera_limit_array[1]
	print("bottom camera: " + str(camera_control.limit_bottom))
	print("right camera: " + str(camera_control.limit_right))


func update_high_score():
	print(current_highscore)
	print(player_score)
	if(current_highscore < player_score):
		var popuppanel = $CanvasLayer/PopupMenuControl
		popuppanel.update_highscore(player_score)
		SaveSystem.save_score(player_score)

func get_next_attacks() -> String:
	if select_attack+1 < attacks_available.size():
		select_attack += 1
	else:
		select_attack = 0
	return attacks_available[select_attack]

func _set_attacks_available(data: Array):
	attacks_available = data

# Function to be used for starting the ranged attack
# attack_direction 	: Decides the direction of attack
# energylevel		: Check out the energy level to execute energy attack
# attack_type 		: AttackType scene to show different attacks
func use_ranged_attack(attack_direction: int, attackType: PackedScene) -> int:
	var attack = attackType.instance()
	var type = attack._get_type()
	if type == "Energy" and energylevel == 0:
		return type
	attack._set_direction(attack_direction)
	attack._set_start_position(position)
	get_parent().add_child(attack)
	attack.position.x = position.x + (10 * attack_direction)
	attack.position.y = position.y
	attack.set_process(true)
	return type

func use_sword_wave_attack(attack_direction: int, 
				attackType: PackedScene) -> void:
	var attack = attackType.instance()
	attack._set_direction(attack_direction)
	attack._set_start_position(position)
	get_parent().add_child(attack)
	attack.position.x = position.x + (40 * attack_direction)
	attack.position.y = position.y
	attack.set_process(true)

#######################################################################
#    Music related functions
#######################################################################

func _play_stage_music(music : String):
	Music._play_music(music)


########################################################################
#			VELOCITY CALCULATION FOR STOMP AND RUNNING
########################################################################


# Calculate the velocity to bounce on stomping an enemy 
# linear_velocity	: current velocity of movement
# impulse			: Impulse value to which the player needs to bounce
func calc_stomp_velocity(
	linear_velocity: Vector2,
	impulse: float
) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.y = -impulse
	return new_velocity

# Calculate velocity for movements and jumps
func calc_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	_speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = _speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		new_velocity.y = _speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity

########################################################################
#			ATTACK RELATED FUNCTIONS FIRE, SWORD, STOMPING
########################################################################
# Function to perform required operation on hit by fire type attacks
# BurnType : Type of burn to decide the action to be executed
func hit_by_fire_attack(BurnType: String):
	if BurnType == "BurnType1":
		$"BurnType1".visible = true
		$"BurnType1/FlameBurn".visible = true
		$"BurnType1/BurnArea".visible = true
	if BurnType == "BurnType2":
		$"BurnType2".visible = true
		$"BurnType2/FlameBurn".visible = true
		$"BurnType2/BurnArea".visible = true
		$AttackArea2D.set_deferred("disabled",true)
	$"Exploding".play()

func hit_by_sword(can_hurt:bool, attack_engaged_direction:int):
	if(can_hurt):
		var power_level: int = get_sword_power()
		_velocity.x = power_level if attack_engaged_direction > 0 else -power_level
		_velocity.y -= 25 * (randi()%20 +1)
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		$"EnemyPhysicArea".set_deferred("disabled", true);
		$"AttackArea2D".set_deferred("disabled", true);
		$"AttackArea2D/AttackArea".set_deferred("disabled", true)
		$"StompingArea".set_deferred("disabled", true);
		$"StompingArea/StompArea".set_deferred("disabled", true);

# Power attack is possible only for small monsters not for bosses
func get_sword_power(small_monster = true) -> int:
	if small_monster:
		return int(randi()%500 + enhancer)
	else:
		return 1

func got_critical_hit() -> int:
	if (randi()%1000) % 7 == 0:
		return randi()%20
	return 1

# Function to perform stomp operation
func perform_stomped_hard_operation(score_points):
	get_tree().get_nodes_in_group("Hero")[0].update_score(score_points)
	queue_free()

##############################################################################################
##############################################################################################
#					PEOPLE AND OBJECT MESSAGE SENDING FUNCTION 							
##############################################################################################
##############################################################################################
func send_threatening():
	if current_player == "AgniPuthiran":
		update_speech_area(threatening_scripts[randi()%(threatening_scripts.size()-1)])
	elif current_player == "BraveGirl":
		update_speech_area(Brave_girl_threatening_scripts[randi()%(Brave_girl_threatening_scripts.size()-1)])

func send_hurt_message():
	if current_player == "AgniPuthiran":
		update_speech_area(pain_scripts[randi()%(pain_scripts.size()-1)])
	elif current_player == "BraveGirl":	
		update_speech_area(brave_girl_pain_scripts[randi()%(brave_girl_pain_scripts.size()-1)])
		
func zombie_threatening_msg():
	$ZombieImage/PlayerSpeechArea/SpeechLayer.text = zombie_scripts[randi()%(zombie_scripts.size()-1)]	

func update_speech_area(text_to_speak: String):
	$PlayerSpeechArea/SpeechLayer.visible = true
	$PlayerSpeechArea/SpeechLayer.text = text_to_speak

#############################################################################################
#				Small fainted enemies updating player data
#############################################################################################
func _update_after_faint(score_points: int, enemy_size = "small_enemy"):
	var player = get_tree().get_nodes_in_group("Hero")[0]
	player.update_score(score_points)
	if(enemy_size == "small_enemy"):
		player.update_kill_count()
		queue_free()

##########################################################################
# 			Methods for getting Player properties
##########################################################################

func get_coin_collected():
	return coin_collected_count

func get_health() -> int:
	return healthlevel

func get_energy() -> int:
	return energylevel

func get_kill_count() -> int:
	return kill_count

func get_score() -> int:
	return player_score

func get_position_x() -> int:
	return int(global_position.x)

func get_position_y() -> int:
	return int(global_position.y)

func _get_highscore() -> int:
	return SaveSystem.load_score()

func _set_highscore(player_score: int) -> void:
	SaveSystem.save_score(player_score)
##########################################################################
# 			Methods for setting Player properties
##########################################################################
func set_coin_collected(value : int):
	coin_collected_count = value

func set_health(value : int):
	healthlevel = value

func set_energy(value: int):
	energylevel = value

func set_kill_count(value: int):
	kill_count = value

func set_score(value: int) :
	player_score = value

#############################################################################
#		Save function for saving the player details for future use
#############################################################################
func save():
	var save_dict = {
		player_info = {
			health = get_health(),
			energy = get_energy(),
			kill_count = get_kill_count(),
			current_score = get_score(),
			max_health_value = max_health,
			max_energy_value = max_energy
			},
		current_scene = get_tree().get_current_scene().get_filename(),
		player_position_info ={
			position_x = get_position_x(),
			position_y = get_position_y()
		}	
	}
	return save_dict

func load_data() -> Dictionary:
	var save_file = File.new()
	if not (save_file.file_exists(SAVE_PATH)):
		return {}
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	for node in data.keys():
		if("Player" in node):
			return data[node]["player_info"]
	return {}
