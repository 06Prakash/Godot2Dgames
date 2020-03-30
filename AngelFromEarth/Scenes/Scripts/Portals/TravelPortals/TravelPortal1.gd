extends Area2D


func _on_Portal_body_entered(body: Node) -> void:
	if body == null:
		return
	if body.name != "Player":
		return
	body._set_is_stage_completed(true)
	body.get_node("CanvasLayer/PopupMenuControl")._open_popup("YOU WON!!", body.current_player)
