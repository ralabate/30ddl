extends StaticBody3D


signal spawned_badguy(position: Vector3)


func _ready() -> void:
	add_to_group("spawners")
	spawned_badguy.emit.call_deferred(position)


func _on_timer_timeout() -> void:
	spawned_badguy.emit(position)
