extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("badguys")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func damage():
	queue_free()
