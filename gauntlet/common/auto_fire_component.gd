extends Node
class_name AutofireComponent


signal fired(bullet: Node3D, direction: Vector3, location: Vector3)

@export var TIME_BETWEEN_SHOTS = 1.0

var bullet_template = preload("res://player/bullet.tscn")
var firing_rate_timer: Timer


func _ready() -> void:
	firing_rate_timer = Timer.new()
	firing_rate_timer.wait_time = TIME_BETWEEN_SHOTS
	firing_rate_timer.autostart = false
	firing_rate_timer.timeout.connect(_on_firing_rate_timer_timeout)
	add_child(firing_rate_timer)


func _on_firing_rate_timer_timeout() -> void:
	var bullet = bullet_template.instantiate()
	var parent = get_parent()
	fired.emit(
		bullet,
		parent.rotation,
		parent.transform.origin - parent.transform.basis.z
	)
