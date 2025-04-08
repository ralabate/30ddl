extends Node3D


var current_level: Level


var levels = [
	#preload("res://level/levels/level_0.tscn"),
	preload("res://level/levels/level_1.tscn"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_next_level()


func play_next_level() -> void:
	if current_level != null and not current_level.is_queued_for_deletion():
		current_level.clean_up()
		current_level.queue_free()

	var level = levels.pick_random().instantiate() as Level
	add_child(level)
	level.player_won.connect(_on_player_won)
	level.player_lost.connect(_on_player_lost)
	
	current_level = level
	
	Log.info("Starting new level [%s]" % level.name)


func _on_player_won() -> void:
	play_next_level()


func _on_player_lost() -> void:
	play_next_level()
