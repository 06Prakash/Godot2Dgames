extends Area2D

onready var animation = $"AnimationPlayer"
var my_score = 50

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Floating")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if(anim_name == "Fading"):
		queue_free()


func _on_Coins_body_entered(body: KinematicBody2D) -> void:
	if(body == null):
		return
	if(body.is_in_group("Hero")):
		animation.play("Fading")
#		var player = get_parent().get_node("Player")
		body.update_score(my_score)
		body.update_coin_collection()
