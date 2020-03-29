extends Area2D

func _on_RectFireWeakSpot_area_entered(area: Area2D) -> void:
	if(area.is_in_group("fire_spot")):
		area.get_parent().hit_by_fire_contact(
			get_parent().get_node("BurnType2").visible
			)
