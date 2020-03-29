extends Node

const SAVE_PATH = "user://Angel_from_earth_save.json"
const score_file = "user://Angel_from_earth_highscore.save"
var settings = {}
var loading_from_file = false
var player_info = {}
# Called when the node enters the scene tree for the first time.
var highscore

func load_score() -> int:
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var data = {}
		data = parse_json(f.get_as_text())
		highscore = data["high_score"]
		f.close()
	else:
		highscore = 0
	return highscore

func save_score(highscore_received: int):
	var f = File.new()
	var data = {
		"high_score" : highscore_received
		}
	f.open(score_file, File.WRITE)
	f.store_line(to_json(data))
	f.close()
	
# I need to follow 4 steps to achieve save functionality
# 1: Pull data from all the save groups.
# 2: Create a file
# 3: Serialize the dictionary values into json values
# 4: Store the json data in the file
func save_game():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group("Save")
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()
	
# I need to follow 4 steps to achieve save functionality
# 1: Pull data from the save file.
# 2: Convert the Json value inot the dictionary value
# 3: Put those values into the corresponding nodes
# 4: Start the scene and the game
func load_game():
	var save_file = File.new()
	if not (save_file.file_exists(SAVE_PATH)):
		return
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	print(typeof(data))
	var required_key
	for node in data.keys():
		if("Player" in node):
			required_key = node
	var status = get_tree().change_scene(data[required_key]["current_scene"])
	print(status)
	loading_from_file = true
	player_info = data[required_key]["player_info"]
