extends ActorScript

export (PackedScene) var MeleeAttackType1
export (PackedScene) var RangedAttackType1
export var stomp_impulse:= 500.0

# Controllers related variables
onready var left_controller = $Controllers/CanvasLayer/Left
onready var right_controller = $Controllers/CanvasLayer/Right
onready var Jump_controller = $Controllers/CanvasLayer/Jump
onready var pause_controller = $Controllers/CanvasLayer/Pause
onready var attack_controller = $Controllers/CanvasLayer/Attack


onready var AttackCoolDownTimer = $"AttackcooldownTimer"
onready var anim_sprite = $"BraveGirl"
onready var EnableEnergyAttack = true
onready var fainted = false
onready var info_node = $"informationLayer/InfoNode"
onready var player_animation = $PlayerAnimation
onready var progress_bar = $"ProgressBar"
onready var protection_globe = $"ProtectionGlobe"
var joystick_controller_jump_released = false
var attack_executed = true
var gun_shot_attack_direction

var total_coin_collected_count:int
var loaded_already_from_file = false


func _ready() -> void:
	current_highscore = ._get_highscore()
	current_player = "BraveGirl"
	attacks_available = ["bullet1"]
	get_camera_limits()
	select_attack = 0
	set_energy(0)
	_set_is_stage_completed(false)
	protection_globe.visible = true
	protected = true
	$ProtectionTimer.start(5)
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
	SaveSystem.loading_from_file = false

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	# Check if the player fainted
	if (not fainted):
		# to check whether the jump is interrupted or not/
		var is_jump_interrupted = (joystick_controller_jump_released or Input.is_action_just_released("jump")) and _velocity.y < 0.0
		# Get the horizontal movement direction
		var direction: = get_direction()
		gun_shot_attack_direction = direction
		# Calculate the velocity of the movement with the direction, speed, jump
		_velocity = calc_velocity(_velocity, direction, speed, is_jump_interrupted)
		# This move_and_slide is used for movement without it player will be stuck in same place
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		if (pause_controller.is_pressed()):
			$"CanvasLayer/PopupMenuControl"._open_popup("In Progress!!", current_player)
		if(Input.is_action_just_pressed("attack") or attack_controller.is_pressed()):
			gun_shot_attack()
		if(Input.is_action_just_pressed("left") or left_controller.is_pressed()):
			anim_sprite.flip_h = true
		elif (Input.is_action_just_pressed("right") or right_controller.is_pressed()):
			anim_sprite.flip_h = false
		elif(Input.is_action_just_pressed("SelectAttack")):
			.get_next_attacks()
		# To check whether we are jumping
		if(_velocity.y < 0.0):
			anim_sprite.play("Jump")
		else:
			if(_velocity.x > 0):
				anim_sprite.flip_h = false
				player_animation.play("RunRight")
#				anim_sprite.play("RunRight");
			if(_velocity.x < 0):
				anim_sprite.flip_h = true
				player_animation.play("RunRight")
#				anim_sprite.play("RunRight");
			if(_velocity.x == 0 and attack_executed):
#				anim_sprite.play("Idle")
					player_animation.play("Idle")


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
func gun_shot_attack():
	if attack_executed:
		player_animation.play("Attack")
		
	
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
		player_animation.play("Dead")
		$"CanvasLayer/PopupMenuControl"._open_popup("DEFEATED!!", current_player)
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
		$"CanvasLayer/PopupMenuControl"._open_popup("Player Fainted", current_player)

# Function to perform when we stomped
func _on_StompingArea_area_entered(area: Area2D) -> void:
	if(area.is_in_group("stomp_area")):
		_velocity = calc_stomp_velocity(_velocity, stomp_impulse)
		area.get_parent().stomped_hard()

func _on_ProtectionTimer_timeout() -> void:
	$PlayerSpeechArea/SpeechLayer.visible = false
	protection_globe.visible = false
	protected = false


func _on_Jump_released() -> void:
	joystick_controller_jump_released = true


func _on_Jump_pressed() -> void:
	joystick_controller_jump_released = false


func _on_NextButtonPopup_pressed() -> void:
	$informationLayer/InfoNode.visible = true
	$"CanvasLayer/StoryAndObjectivePopup"._toggle_popup(false)


func _on_PlayerAnimation_animation_finished(anim_name: String) -> void:
	player_animation.stop(true)
	if(anim_name == "Attack"):
		attack_executed = true


func _on_PlayerAnimation_animation_started(anim_name: String) -> void:
	if(anim_name == "Attack" and anim_sprite != null):
		$"AttackcooldownTimer".start(0.3)
		var attack_direction = 1
		if anim_sprite.is_flipped_h():
			attack_direction = -1
		.use_ranged_attack(attack_direction, RangedAttackType1)
		attack_executed = false
		if((randi()%100) % 5 == 0):
			send_threatening()



func _on_AttackcooldownTimer_timeout() -> void:
	attack_executed = true
