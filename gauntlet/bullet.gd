extends Area3D


@export var SPEED = 5


func _ready() -> void:
	add_to_group("player_bullets")


func _physics_process(delta: float) -> void:
	translate_object_local(Vector3.FORWARD * SPEED * delta)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("badguys"):
		body.damage()

	queue_free()
