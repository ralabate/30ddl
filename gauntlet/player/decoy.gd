extends Area3D


signal done(affected_list: Array[Node3D])

@onready var visual: MeshInstance3D = %Visual
@onready var lifetime_timer: Timer = %LifetimeTimer

var baduy_list = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("badguys"):
		body.target = self
		baduy_list.append(body)


func _on_lifetime_timer_timeout() -> void:
	done.emit(baduy_list)
	queue_free()
