extends Sprite

onready var health = $"Health/HealthDisplay"
onready var energy = $"Energy/EnergyDisplay"
onready var kill_count = $"KillCount/KillCountDisplay"
onready var coins_collected_count = $"Coins/CoinsDisplay"
onready var current_score = $"CurrentScore/CScoreDisplay"
onready var hi_score = $"HighScore/HscoreDisplay"
var parent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	update_health(1,1)
	update_energy(1,1)
	update_kill_count(0)
	while(parent.name != "Player"):
		parent = parent.get_parent()

func _process(_delta: float) -> void:
	var health_level = parent.get_health()
	update_health(health_level, 6.0)
	var energy_level = parent.get_energy()
	update_energy(energy_level, 1.0)
	var killcount = parent.get_kill_count()
	update_kill_count(killcount)
	var coin_collected = parent.get_coin_collected()
	update_coins_collected_count(coin_collected)
	var score = parent.get_score()
	update_current_score_board(score)

func update_health(health_level: int, max_health: float):
	health.text = str(int(float(health_level / max_health) * 100))

func update_energy(energy_level: int, max_energy: float):
	energy.text = str(int(float(energy_level / max_energy) * 100))

func update_kill_count(killcount: int):
	kill_count.text = str(killcount)

func update_current_score_board(score: int):
	current_score.text = str(score)

func update_coins_collected_count(coins_collected: int):
	coins_collected_count.text = str(coins_collected)

func update_hi_score(score: int):
	hi_score.text = str(score)
