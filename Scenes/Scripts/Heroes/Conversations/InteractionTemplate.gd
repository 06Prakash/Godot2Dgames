extends Node2D
onready var pointer = $AnimatedSprite/Pointer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pointer.visible = false
	$AnimatedSprite.play("Idle")

func _show_pointer():
	pointer.visible = true

func _hide_pointer():
	pointer.visible = false
