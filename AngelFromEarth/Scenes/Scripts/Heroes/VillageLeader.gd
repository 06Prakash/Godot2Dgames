extends ActorScript

export (PackedScene) var MeleeAttackType1
export (PackedScene) var InformationScene
export var stomp_impulse:= 500.0

# Controllers related variables
onready var left_controller = $Controllers/CanvasLayer/Left
onready var right_controller = $Controllers/CanvasLayer/Right
onready var Jump_controller = $Controllers/CanvasLayer/Jump
onready var pause_controller = $Controllers/CanvasLayer/Pause
onready var attack_controller = $Controllers/CanvasLayer/Attack
onready var meleeattackTimer = $"MeleeAttackMaintainingTimer"
onready var anim_sprite = $"VillageLeader"
onready var attack_sprite = $"AttackSprite"
onready var EnableEnergyAttack = true
onready var fainted = false
onready var fainting_animation = $"LeaderAnimation"
onready var info_node = $"informationLayer/InfoNode"
onready var sword_attack_area = $"AttackSprite/SwordRangeArea"
onready var progress_bar = $"ProgressBar"
onready var protection_globe = $"ProtectionGlobe"


var wait_for_next_attack = false

var total_coin_collected_count:int
var loaded_already_from_file = false


func _ready() -> void:
	current_highscore = ._get_highscore()
	get_camera_limits()
	if(current_highscore == null):
		current_highscore = 0
	$"CanvasLayer/PopupMenuControl".update_highscore(current_highscore)
	attacks_available = ["sword1"]
	current_player = "AgniPuthiran"
	_set_is_stage_completed(false)
	attack_sprite.visible = false
	protection_globe.visible = true
	protected = true
	$ProtectionTimer.start(5)
	sword_attack_area.set_deferred("disabled",true)
	speed = Vector2(500.0, 1200.0)
	if(SaveSystem.loading_from_file):
		var player_info = load_data()
		_set_load_resource(player_info)
		SaveSystem.loading_from_file = false
	else:
		max_health = 6
		.set_health(max_health)
	progress_bar._update_progress_bar((healthlevel * 100)/max_health)
	update_info_layer()
	
func _set_is_stage_completed(status : bool):
	stage_completed = status

func _get_is_stage_completed() -> bool:
	return stage_completed


func _set_load_resource(player_info):
	healthlevel = player_info["health"]
	player_score = player_info["current_score"]
	max_health = player_info["max_health_value"]
	SaveSystem.loading_from_file = false

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	# Check if the player fainted
	if (not fainted):
		# to check whether the jump is interrupted or not/
		var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
		# Get the horizontal movement direction
		var direction: = get_direction()
		melee_attack_direction = direction
		# Calculate the velocity of the movement with the direction, speed, jump
		_velocity = calc_velocity(_velocity, direction, speed, is_jump_interrupted)
		# This move_and_slide is used for movement without it player will be stuck in same place
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		if (pause_controller.is_pressed()):
			$"CanvasLayer/PopupMenuControl"._open_popup("In Progress!!", current_player)
		if(Input.is_action_just_pressed("attack") or (attack_controller.is_pressed() and wait_for_next_attack)):
			melee_attack()
			return
		if(Input.is_action_just_pressed("left")):
			anim_sprite.flip_h = true
			attack_sprite.flip_h = true
			if sword_attack_area.position.x > 0:
				sword_attack_area.position.x *= -1
		elif (Input.is_action_just_pressed("right")):
			anim_sprite.flip_h = false
			attack_sprite.flip_h = false
			if sword_attack_area.position.x < 0:
				sword_attack_area.position.x *= -1
		elif(Input.is_action_just_pressed("SelectAttack")):
			attack_selection()
		# To check whether we are jumping
		if(_velocity.y < 0.0):
			anim_sprite.play("Jump")
			anim_sprite.playing = true
		else:
			if(_velocity.x > 0):
				anim_sprite.play("RunRight");
				anim_sprite.flip_h = false
			if(_velocity.x < 0):
				anim_sprite.play("RunRight");
				anim_sprite.flip_h = true
			if(_velocity.x == 0):
				anim_sprite.play("Idle")


# Function to select the attack
func attack_selection():
	info_node.attackSelected(attacks_available[select_attack])

# Function to get the direction in which the movement should happen
func get_direction() -> Vector2:
	return Vector2(
		get_horizontal_movement(),
		-1.0 if ((Jump_controller.is_pressed() or Input.is_action_just_pressed("jump")) and is_on_floor()) else 1.0
	)

# Function to get the horizontal movement
func get_horizontal_movement() -> float:
	if right_controller.is_pressed():
		return 1.0
	elif left_controller.is_pressed():
		return -1.0
	else:
		return Input.get_action_strength("right")-Input.get_action_strength("left")

# Function to use ranged attack
func melee_attack():
	if melee_attack_ended:
		anim_sprite.visible = false
		attack_sprite.visible = true
		attack_sprite.play("Attack")
		var attack_direction = 1
		if anim_sprite.is_flipped_h():
			attack_sprite.flip_h = true
			attack_direction = -1
			engaged_attack_direction = attack_direction
			if sword_attack_area.position.x > 0:
				sword_attack_area.position.x *= -1
		else:
			attack_sprite.flip_h = false
			if sword_attack_area.position.x < 0:
				sword_attack_area.position.x *= -1
		.use_sword_wave_attack(attack_direction, MeleeAttackType1)
		sword_attack_area.set_deferred("disabled",false)
		melee_attack_ended = false
		$"SwordAttack".play()
		if((randi()%100) % 5 == 0):
			send_threatening()
		meleeattackTimer.start(0.5)

# Function to reduce the health of the player if got hit
func reduce_health():
	if protected:
		return
	elif (healthlevel > 1):
		protected = true
		$ProtectionGlobe.visible = true
		$ProtectionTimer.start(5)
		healthlevel -= 1
		send_hurt_message()
	else:
		fainted = true
		$"LeaderAnimation".play("Dead")
		$"CanvasLayer/PopupMenuControl"._open_popup("DEFEATED!!")
	progress_bar._update_progress_bar((healthlevel * 100)/max_health)

##########################################################################
# 			Method for Updating Player properties
##########################################################################
# Function to update the player score in the screen
func update_score(score : int):
	player_score += score
	info_node.update_score(player_score)

func update_kill_count():
	kill_count += 1

func update_coin_collection():
	coin_collected_count += 1

# Function to update the information layer
func update_info_layer():
	update_score(0)
	attack_selection()


# Animation running function when the player health drops to zero
func _on_BoyAnimation_animation_finished() -> void:
	if(fainted):
		$"CanvasLayer/PopupMenuControl"._open_popup("Player Fainted")

# Function to perform when we stomped
func _on_StompingArea_area_entered(area: Area2D) -> void:
	if(area.is_in_group("stomp_area")):
		_velocity = calc_stomp_velocity(_velocity, stomp_impulse)
		area.get_parent().stomped_hard()

func _on_SwordRangeArea_area_entered(area: Area2D) -> void:
	if(area.is_in_group("enemy_ranged_attack_spot")):
		area.get_parent().hit_by_sword(area.get_parent().get_can_hurt(), engaged_attack_direction)

func _on_MeleeAttackTimer_timeout() -> void:
	melee_attack_ended = true
	attack_sprite.visible = false
	$PlayerSpeechArea/SpeechLayer.text = ""
	anim_sprite.visible = true
	sword_attack_area.set_deferred("disabled",true)

func _on_LeaderAnimation_animation_finished(anim_name: String) -> void:
	if(anim_name == "Attack"):
		melee_attack_ended = true

func _on_ProtectionTimer_timeout() -> void:
	protection_globe.visible = false
	protected = false


func _on_Attack_pressed() -> void:
	wait_for_next_attack = true


func _on_Attack_released() -> void:
	wait_for_next_attack = false


func _on_NextButtonPopup_pressed() -> void:
	get_tree().get_nodes_in_group("stage")[0].try_start_game()
