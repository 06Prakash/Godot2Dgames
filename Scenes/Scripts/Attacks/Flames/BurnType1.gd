extends Area2D

onready var flame_burn = $FlameBurn
# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flame_burn.play("burning")


func _on_BurnType1_area_entered(area: Area2D) -> void:
	if(area.is_in_group("fire_spot")):
		area.get_parent().hit_by_fire_attack("BurnType1")
		queue_free()


