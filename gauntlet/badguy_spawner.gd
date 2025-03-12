extends StaticBody3D


signal spawn_badguy(position: Vector3)

@onready var timer = %Timer


func _ready() -> void:
	add_to_group("spawners")
	timer.start()


func _on_timer_timeout() -> void:
	spawn_badguy.emit(global_position)
