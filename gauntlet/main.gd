extends Node3D


var levels = [
	preload("res://level_0.tscn"),
	preload("res://level_1.tscn"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = levels.pick_random().instantiate()
	add_child(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
