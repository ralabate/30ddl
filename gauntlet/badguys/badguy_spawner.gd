extends StaticBody3D


signal spawned_badguy(position: Vector3)
signal death

@onready var health_component: HealthComponent = %HealthComponent


func _ready() -> void:
	add_to_group("spawners")
	health_component.death.connect(_on_death)


func _on_timer_timeout() -> void:
	spawned_badguy.emit(position)


func _on_death() -> void:
	death.emit()
	queue_free()
