extends StaticBody3D


signal spawned_badguy(badguy: Node3D, position: Vector3)
signal death

@export var badguy_template: PackedScene

@onready var health_component: HealthComponent = %HealthComponent


func _ready() -> void:
	health_component.death.connect(_on_death)


func _on_timer_timeout() -> void:
	spawned_badguy.emit(badguy_template.instantiate(), position)


func _on_death() -> void:
	death.emit()
	queue_free()
